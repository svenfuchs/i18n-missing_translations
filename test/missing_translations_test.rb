require File.expand_path('../test_helper', __FILE__)
require 'yaml'
module AdvaCoreTests
  class I18nMissingTranslationsLogTest < Minitest::Spec
    attr_reader :filename

    def setup
      @filename = '/tmp/i18n_missing_translations/missing_translations.yml'
      FileUtils.mkdir_p(File.dirname(filename))
      I18n.available_locales = [:en]
    end

    def teardown
      File.rm(filename) rescue nil
      I18n.missing_translations.clear
    end

    it 'logs to a memory hash' do
      log = I18n::MissingTranslations::Log.new
      log.log([:missing_translations, :foo])
      log.log([:missing_translations, :bar, :baz, :boz])
      log.log([:missing_translations, :bar, :baz, :buz])

      expected = { 'missing_translations' => { 'foo' => 'Foo', 'bar' => { 'baz' => { 'boz' => 'Boz', 'buz' => 'Buz' } } } }
      assert_equal expected, log
    end

    it 'dumps memory log as a yaml hash' do
      log = I18n::MissingTranslations::Log.new
      log.log([:missing_translations, :foo, :bar])
      log.dump(out = StringIO.new)

      expected = { 'missing_translations' => { 'foo' => { 'bar' => 'Bar' } } }
      assert_equal expected, YAML.load(out.string)
    end

    it 'works as a rack middleware' do
      File.open(filename, 'w+') { |f| f.write(YAML.dump('en' => { 'foo' => 'Foo' })) }
      middleware = I18n::MissingTranslations.new(lambda { |*| I18n.t(:missing) }, filename)
      middleware.call({})
      assert_equal({ 'en' => { 'foo' => 'Foo', 'missing' => 'Missing' }}, YAML.load_file(filename))
    end

    it 'works as a middleware that reads an existing locale file, subsequently adds missing translations and writes them back' do
      File.open(filename, 'w+') { |f| f.write(YAML.dump('en' => { 'foo' => 'Foo' })) }
      app = lambda { I18n.t(:first_miss) }
      middleware = I18n::MissingTranslations.new(lambda { |*| app.call }, filename)
      middleware.call({})
      assert_equal({ 'en' => { 'foo' => 'Foo', 'first_miss' => 'First Miss' }}, YAML.load_file(filename))

      app = lambda { I18n.t(:second_miss) }
      middleware.call({})
      assert_equal({ 'en' => { 'foo' => 'Foo', 'first_miss' => 'First Miss', 'second_miss' => 'Second Miss' }}, YAML.load_file(filename))
    end
  end
end


