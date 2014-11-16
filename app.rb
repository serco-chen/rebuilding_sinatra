$:.unshift "#{File.dirname(__FILE__)}"

# app.rb
require './lib/sinatra'

class Sinatra::Base

  get '/' do
    ['200', {'Content-Type' => 'text/html'}, ['You are in the root page']]
  end

  get '/posts' do
    ['200', {'Content-Type' => 'text/html'}, ['You are in the posts page']]
  end

  post '/posts' do
    ['200', {'Content-Type' => 'text/html'}, ['You just post to the posts page']]
  end
end


Sinatra::Base.run!
