$:.unshift "#{File.dirname(__FILE__)}"

# app.rb
require './lib/sinatra'

get '/' do
  ['200', {'Content-Type' => 'text/html'}, ['You are in the root page']]
end

get '/posts' do
  if id = params["id"]
    ['200', {'Content-Type' => 'text/html'}, ["You are view post number #{id}"]]
  else
    ['200', {'Content-Type' => 'text/html'}, ['You are in the posts page']]
  end
end

post '/posts' do
  ['200', {'Content-Type' => 'text/html'}, ['You just post to the posts page']]
end


Sinatra::Base.run!
