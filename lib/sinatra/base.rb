require 'rack'

module Sinatra
  class Base
    class << self
      def call(env)
        ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.']]
      end

      def run!
        handler = Rack::Handler.get("puma")
        handler.run(self, {Port: 4567, Host: '0.0.0.0'})
      end
    end
  end
end
