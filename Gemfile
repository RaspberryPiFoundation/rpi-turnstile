# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Specify your gem's dependencies in rpi_turnstile.gemspec.
gemspec

gem 'importmap-rails'
gem 'puma'
gem 'sprockets-rails'
gem 'stimulus-rails'

group :development do
  gem 'debug'
  gem 'openssl'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
end

group :test, :development do
  gem 'dotenv-rails', require: 'dotenv/rails-now'
end

group :test do
  gem 'capybara'
  gem 'climate_control'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'webdrivers'
  gem 'webmock'
end
