# frozen_string_literal: true

source "https://rubygems.org"

gem "hyrax", "~> 5.1.0"
gem 'bootsnap', '>= 1.1.0', require: false
gem 'bootstrap', '~> 4.0'
gem 'coffee-rails', '~> 4.2'
gem 'dalli'

# Required because grpc and google-protobuf gem's binaries are not compatible with Alpine Linux.
# To install the package in Alpine: `apk add ruby-grpc`
# The pinned versions should match the version provided by the Alpine packages.

# Disabled due to dependency mismatches in Alpine packages (grpc 1.62.1 needs protobuf ~> 3.25)
# if RUBY_PLATFORM =~ /musl/
#   path '/usr/lib/ruby/gems/3.3.0' do
#     gem 'google-protobuf', '~> 3.24.4', force_ruby_platform: true
#     gem 'grpc', '~> 1.62.1', force_ruby_platform: true
#   end
# end

gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'okcomputer'
gem 'pg', '~> 1.3'
gem 'puma'
gem 'rails', '~> 7.2', '< 8.0'
gem 'riiif', '~> 2.1'
gem 'rsolr', '>= 1.0', '< 3'
gem 'sass-rails', '~> 6.0'
gem 'sidekiq', '~> 7.0'
gem 'turbolinks', '~> 5'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'uglifier', '>= 1.3.0'
gem 'activerecord-nulldb-adapter', '~> 1.1'

# Auth
gem 'devise'
gem 'devise-guests', '~> 0.8'
gem 'omniauth', '~> 2.0'
gem 'omniauth-cas', '~> 3.0'
gem "omniauth-rails_csrf_protection"
gem 'ldap_groups_lookup', '~> 0.11.0'
gem 'hydra-role-management'

# Profiling
gem 'rack-mini-profiler', require: ['prepend_net_http_patch']
gem 'stackprof', require: false

group :development do
  gem 'better_errors' # add command line in browser when errors
  gem 'binding_of_caller' # deeper stack trace used by better errors

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  gem 'localhost'
end

group :development, :test do
  gem 'debug', '>= 1.0.0'
  gem 'pry-doc'
  gem 'pry-rails'
  gem 'pry-rescue'
end
