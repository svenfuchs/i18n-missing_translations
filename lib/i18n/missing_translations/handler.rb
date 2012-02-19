module I18n
  class MissingTranslations
    module Handler
      def call(exception, locale, key, options)
        I18n.missing_translations.log(exception.keys) if MissingTranslation === exception
        super
      end
    end
  end
end
