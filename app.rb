# app.rb
$:.unshift "#{File.dirname(__FILE__)}"

require './lib/sinatra'

get '/' do
  ['200', {'Content-Type' => 'text/html'}, ['You are in the root page.']]
end

get '/posts' do
  ['200', {'Content-Type' => 'text/html'}, ['You are in the posts page.']]
end

get '/posts/:post_id' do
  id = params["post_id"]
  ['200', {'Content-Type' => 'text/html'}, ["You are reading post number #{id}."]]
end

get %r{\/comments\/([\d]+)} do
  id = params["captures"].first
  ['200', {'Content-Type' => 'text/html'}, ["You are reading comment number #{id}."]]
end

get '/*/comments' do
  content = params["splat"].first
  ['200', {'Content-Type' => 'text/html'}, ["You are reading comments for \"#{content}\"."]]
end

post '/posts' do
  ['200', {'Content-Type' => 'text/html'}, ["You just posted to the posts page."]]
end
