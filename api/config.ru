require 'rubygems'
require 'bundler'

Bundler.require

ENV['DATABASE_URL'] = "mysql://root@localhost/namey"

require './namey_app'
#run NameyApp
run Sinatra::Application
