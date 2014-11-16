$:.unshift "#{File.dirname(__FILE__)}"

# app.rb
require './lib/sinatra'

Sinatra::Base.run!
