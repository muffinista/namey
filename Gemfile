source 'https://rubygems.org'

# Specify your gem's dependencies in namey.gemspec
gemspec
    
# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem "shoulda", ">= 0"
  gem "rspec"

  gem "watchr"
end

#
# couple extra gems for testing db connectivity
#
group :test do
  gem 'simplecov', :require => false
  gem "sequel"
  gem "sqlite3", :platform => :ruby
  gem "jdbc-sqlite3", :platform => :jruby
end
