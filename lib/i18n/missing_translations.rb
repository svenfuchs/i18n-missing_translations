require 'i18n'
require 'i18n/exceptions'

module I18n
  class << self
    attr_writer :missing_translations

    def missing_translations
      @missing_translations ||= MissingTranslations::Log.new
    end
  end

  class MissingTranslations
    autoload :Log, 'i18n/missing_translations/log'
    autoload :Handler, 'i18n/missing_translations/handler'

    attr_reader :app, :filename

    def initialize(app, filename = nil)
      @app = app
      @filename = filename || guess_filename
    end

    def call(*args)
      log.read(filename)
      app.call(*args).tap { log.write(filename) }
    end

    def log
      I18n.missing_translations
    end

    def guess_filename
      if File.directory?("#{Dir.pwd}/log")
        "#{Dir.pwd}/log/missing_translations.log"
      else
        "/tmp/#{File.dirname(Dir.pwd)}-missing_translations.log"
      end
    end
  end

  ExceptionHandler.send(:include, MissingTranslations::Handler)
end
