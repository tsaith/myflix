source 'https://rubygems.org'
ruby '2.1.5'

gem 'bootstrap-sass', '3.1.1.1'
gem 'coffee-rails', '4.0.1'
gem 'rails', '4.1.1'
gem 'haml-rails', '0.5.3'
gem 'sass-rails', '4.0.3'
gem 'uglifier', '2.3.1'
gem 'jquery-rails', '3.0.4'
gem 'pg', '0.17.0'
gem 'bootstrap_form', '2.2.0'
gem 'bcrypt-ruby', '3.1.2'
gem 'sluggable_th', '0.0.0'
gem 'fabrication', '2.11.3'
gem 'faker', '1.4.3'
gem 'sidekiq', '3.3.0'
gem 'unicorn', '4.8.3'
gem 'paratrooper', '2.4.1'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'figaro', '1.0.0'
gem 'carrierwave', '0.10.0'
gem 'mini_magick', '4.0.2'
gem 'fog', '1.27.0'
gem 'draper', '1.4.0'

group :development do
  gem 'thin', '1.5.0'
  gem "better_errors", '1.0.1'
  gem "binding_of_caller", '0.7.2'
  gem 'guard', '2.6.1'
  gem 'guard-livereload', '2.3.1'
  gem 'letter_opener', '1.3.0'
end

group :development, :test do
  gem 'pry', '0.9.12.3'
  gem 'pry-nav', '0.2.3'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'database_cleaner', '1.2.0'
  gem 'shoulda-matchers', '2.7.0', require: false
  gem 'capybara', '2.4.4'
  gem 'capybara-email', '2.4.0'
  gem 'launchy', '2.4.3'
  gem 'rspec-sidekiq', '1.1.0'
  gem 'vcr', '2.9.3'
  gem 'webmock', '1.20.4'
  gem 'selenium-webdriver', '2.44.0'
  gem 'capybara-webkit', '1.4.1'
end

group :production, :staging do
  gem 'rails_12factor', '0.0.2'
  gem "sentry-raven", '0.12.2'
end

