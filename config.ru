# Gemfile
require "rubygems"
require "bundler/setup"
require "sinatra"
load "app.rb"
 
set :run, false
set :raise_errors, true
 
run Sinatra::Application