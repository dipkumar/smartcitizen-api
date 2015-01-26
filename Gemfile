source 'https://rubygems.org'

gem 'rails', '4.2.0'
gem 'rails-api'
gem 'sqlite3'
gem 'bcrypt', '~> 3.1.7'
gem 'cassandra-driver', require: false
gem 'cequel', github: 'cequel/cequel'
gem 'active_model_serializers', github: 'rails-api/active_model_serializers', branch: '0-9-stable'
gem 'oauth2', require: false
gem 'doorkeeper'
gem 'versionist'

group :test do
  gem 'database_cleaner'
  gem 'simplecov', require: false
  gem 'zonebie'
end

group :development do
  gem 'quiet_assets'
  gem 'spring-commands-rspec'
  gem 'letter_opener'
end

group :development, :test do
  gem 'ffaker'
  gem 'figaro'
  gem 'spring'
  gem 'brakeman', github: 'presidentbeef/brakeman', require: false
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers', require: false
  gem 'guard-rspec'
  # gem 'byebug'
  # gem 'web-console', '~> 2.0'
end


# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'