require 'rack'

module Sinatra
  class Base
    def call(env)
      @request = Rack::Request.new(env)
      if @request.path_info == '/'
        ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.']]
      else
        ['404', {'Content-Type' => 'text/html'}, ['Not found.']]
      end
    end

    class << self
      # Instantiate self for each request in case that requests will
      # interfere with each other.
      def call(env)
        new.call(env)
      end

      def run!
        handler = Rack::Handler.get("puma")
        handler.run(self, {Port: 4567, Host: '0.0.0.0'})
      end
    end
  end
end
