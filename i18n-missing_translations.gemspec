# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'i18n/missing_translations/version'

Gem::Specification.new do |s|
  s.name         = "i18n-missing_translations"
  s.version      = I18n::MissingTranslations::VERSION
  s.authors      = ["Sven Fuchs"]
  s.email        = "svenfuchs@artweb-design.de"
  s.homepage     = "http://github.com/svenfuchs/i18n-missing_translations"
  s.summary      = "Find missing translations in your code more easily"
  s.description  = "Find missing translations in your code more easily."

  s.files        = `git ls-files app lib`.split("\n")
  s.platform     = Gem::Platform::RUBY
  s.require_path = 'lib'
  s.rubyforge_project = '[none]'

  s.add_dependency 'i18n', '~> 0.6.0'
  s.add_development_dependency 'test_declarative'
end
