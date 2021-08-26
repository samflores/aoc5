# frozen_string_literal: true

require 'bundler/setup'
require 'minitest'
require 'simplecov'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

if ENV['COVERAGE']
  SimpleCov.start do
    enable_coverage :branch
    filters.clear

    track_files '**/*.rb'
    add_filter 'specs'
  end
end
