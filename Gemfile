source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 6.1.7', '>= 6.1.7.1'
# Use postgresql as the database for Active Record
gem 'pg', '~> 1.1'
# Use Puma as the app server
gem 'puma', '~> 5.0'

# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  gem 'listen', '~> 3.3'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

#image file upload
gem 'activestorage'

#serializer support
gem 'active_model_serializers'

#S3 support
gem "aws-sdk-s3", require: false

#actionmailer for sending mail
gem 'actionmailer'

#stripe for accepting payments
gem 'stripe'

#support for ed25519
gem  'ed25519', '~> 1.2'
gem 'bcrypt_pbkdf', '~> 1.0'

#gems for watermarks
gem "image_processing", "~> 1.0"
gem "ruby-vips"

#gem for multitenancy
gem 'activerecord-multi-tenant'