# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.3.14'

# --- Framework -------------------------------------------------------------
gem 'puma', '~> 7.2', '>= 7.2.2' # patched for GHSA-xw3h-pgr9-3vg7 (100-Continue reactor stall)
gem 'rack-attack' # rate limiting / brute-force & abuse protection
gem 'rails', '~> 8.1.0'
gem 'sprockets-rails'
# Pin to the 2.x line: json 3.x drops the legacy quirks_mode keyword that the
# Rack/Warden session stack still relies on.
gem 'json', '~> 2.7'
gem 'sqlite3', '~> 2.1'

# --- Front-end -------------------------------------------------------------
gem 'importmap-rails'
gem 'jbuilder'
gem 'stimulus-rails'
gem 'turbo-rails'

# --- Domain gems -----------------------------------------------------------
gem 'acts-as-taggable-on'
gem 'cancancan'
gem 'devise'
gem 'image_processing', '>= 1.2'
gem 'will_paginate', '~> 4.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

group :development, :test do
  gem 'bullet' # surface N+1 queries in development/test
  gem 'debug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails'

  # Static analysis & supply-chain security
  gem 'brakeman', require: false # SAST for Rails
  gem 'bundler-audit', require: false # CVE scan of the dependency tree
  gem 'rubocop', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end

group :development do
  gem 'web-console'
end

group :test do
  gem 'capybara'
  gem 'selenium-webdriver' # Selenium Manager resolves drivers (webdrivers gem is EOL)
end
