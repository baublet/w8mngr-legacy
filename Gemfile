source "https://rubygems.org"
ruby "2.3"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "4.2.6"

# Replace WEBRick with Puma
gem "puma"

# Use SCSS for stylesheets
gem "sass-rails", "~> 5.0"

# Use Uglifier as compressor for JavaScript assets
gem "uglifier", ">= 1.3.0"

# bundle exec rake doc:rails generates the API under doc/api.
gem "sdoc", "~> 0.4.0", group: :doc

# Use ActiveModel has_secure_password
gem "bcrypt", "~> 3.1.7"

# For our unit conversions and displays
gem "ruby-units"

# For converting dates and times entered in the user field
gem "chronic"
gem "chronic_duration"

# PostgreSQL
gem "pg"
# A brilliant PG Search gem to use native PG searching abilities
gem "pg_search"

# Markdown processor
gem "redcarpet"

# For my custom API integrations
gem "httparty"

# For our tags!
gem "acts-as-taggable-on"

# Resque, our queueing engine
gem "resque"

# Postmark, for sending our transactional emails postmarkapp.com
gem "postmark"

# For our charting, groupdate and calculate_all makes things easier
gem "groupdate"

# Webpack for rails
gem "webpack-rails"


group :development, :test do

    # For helping us estimate test coverate
    gem "codeclimate-test-reporter", group: :test, require: nil

    gem "sqlite3"
    gem "byebug"
    gem "web-console", "~> 2.0"
    gem "spring"
    gem "therubyracer", platforms: :ruby
    gem "foreman"
    gem "brakeman"
    gem "bullet"
    gem "hologram"

    gem "guard", :require => false

    # For generating fake data
    gem "faker"
end


group :production do
    gem "rails_12factor"
end