require 'rack'

module Sinatra
  class Base
    def call(env)
      @request = Rack::Request.new(env)

      # test the path_info with each route controller
      self.class.routes[@request.request_method].each do |path, block|
        next unless path.match @request.path_info
        return block.call
      end

      # return 404 when no routes match
      ['404', {'Content-Type' => 'text/html'}, ['Not found.']]
    end

    class << self
      attr_reader :routes

      def reset!
        @routes = {}
      end

      # Instantiate self for each request in case that requests will
      # interfere with each other.
      def call(env)
        new.call(env)
      end

      def run!
        handler = Rack::Handler.get("puma")
        handler.run(self, {Port: 4567, Host: '0.0.0.0'})
      end

      def get(path, &block)     route 'GET',     path, &block end
      def head(path, &block)    route 'HEAD',    path, &block end
      def post(path, &block)    route 'POST',    path, &block end
      def put(path, &block)     route 'PUT',     path, &block end
      def patch(path, &block)   route 'PATCH',   path, &block end
      def delete(path, &block)  route 'DELETE',  path, &block end
      def options(path, &block) route 'OPTIONS', path, &block end

      # store defined route controllers in @routes, so it can be
      # retrieved by incoming requests.
      def route(verb, path, &block)
        (@routes[verb] ||= []) << [path, block]
      end
    end

    reset!

  end
end
