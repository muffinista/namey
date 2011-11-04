require 'rubygems'
require 'bundler'

Bundler.require

require './namey_app'
#run NameyApp
run Sinatra::Application
