require File.expand_path('../test_helper', __FILE__)

module AdvaCoreTests
  class I18nMissingTranslationsLogTest < Test::Unit::TestCase
    attr_reader :filename

    def setup
      @filename = '/tmp/test_missing_translations.log'
      FileUtils.mkdir_p(File.dirname(filename))
    end

    def teardown
      File.rm(filename) rescue nil
      I18n.missing_translations.clear
    end

    test 'logs to a memory hash' do
      log = I18n::MissingTranslations::Log.new
      log.log([:missing_translations, :foo])
      log.log([:missing_translations, :bar, :baz, :boz])
      log.log([:missing_translations, :bar, :baz, :buz])

      expected = { 'missing_translations' => { 'foo' => 'Foo', 'bar' => { 'baz' => { 'boz' => 'Boz', 'buz' => 'Buz' } } } }
      assert_equal expected, log
    end

    test 'dumps memory log as a yaml hash' do
      log = I18n::MissingTranslations::Log.new
      log.log([:missing_translations, :foo, :bar])
      log.dump(out = StringIO.new)

      expected = '---  missing_translations:    foo:      bar: Bar '
      assert_equal expected, out.string.gsub("\n", ' ')
    end

    test 'works as a rack middleware' do
      File.open(filename, 'w+') { |f| f.write(YAML.dump('en' => { 'foo' => 'Foo' })) }
      middleware = I18n::MissingTranslations.new(lambda { |*| I18n.t(:missing) }, filename)
      middleware.call({})
      assert_equal({ 'en' => { 'foo' => 'Foo', 'missing' => 'Missing' }}, YAML.load_file(filename))
    end
  end
end


