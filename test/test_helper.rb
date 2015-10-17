require 'rubygems'
require 'bundler/setup'
# require 'test_declarative'
require 'minitest/autorun'
require 'minitest/spec'

$: << File.expand_path('../../lib', __FILE__)
require 'i18n/missing_translations'
