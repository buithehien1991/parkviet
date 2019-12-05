source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use mysql as the database for Active Record
gem 'mysql2', '>= 0.4.4', '< 0.6.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', git: 'https://github.com/codahale/bcrypt-ruby.git', :require => 'bcrypt'

# Use ActiveStorage variant
gem 'mini_magick', '~> 4.9'
gem 'image_processing', '~> 1.2'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'wdm', '>= 0.1.0' if Gem.win_platform?

gem 'devise', '~> 4.7.1'

# Gem group for UI
gem 'bootstrap', '~> 4.3.1'
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'font-awesome-rails'
gem 'toastr-rails'
gem 'acts_as_tree'

# Track changes to your models' data. Good for auditing or versioning.
gem 'paper_trail', '~> 9.0.2'

# Authorization to system
# gem 'pundit', '~> 1.1.0'

# Translate date time class in date_select tag
gem 'rails-i18n'

# Search: Elasticsearch 6.0.2
gem 'chewy', '~> 5.1.0'

# Paginate
gem 'will_paginate', '~> 3.1.6'

# Search Engine Optimization (SEO) plugin for Ruby on Rails applications.
gem 'meta-tags'

# ActiveRecord utilities
gem 'ransack', '~> 1.8.8'

# JSON format
gem 'active_model_serializers'
gem 'numbers_and_words'

# Export file
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'