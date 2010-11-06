require 'rubygems'
require 'test/unit'
require 'bundler/setup'
require 'test_declarative'

$: << File.expand_path('../../lib', __FILE__)
require 'i18n/missing_translations'
