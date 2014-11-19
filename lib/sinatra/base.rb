require 'rack'
require 'uri'

module Sinatra
  class Base

    attr_reader :params

    def call(env)
      @request = Rack::Request.new(env)
      @params = @request.params

      dispatch!
    end

    def dispatch!
      # test the path_info with each route controller
      values = []
      self.class.routes[@request.request_method].each do |pattern, keys, block|
        next unless match = pattern.match(@request.path_info)
        values += match.captures.map! { |v| URI.unescape(v) if v }

        if values.any?
          @params = params.merge('splat' => [], 'captures' => values)
          keys.zip(values) { |k,v| Array === @params[k] ? @params[k] << v : @params[k] = v if v }
        end

        # eval block in instance context, so params can be accessed in block
        return instance_eval(&block)
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

      def inherited(subclass)
        subclass.reset!
        super
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
        pattern, keys = compile path
        (@routes[verb] ||= []) << [pattern, keys, block]
      end

      def compile(path)
        # String like object
        if path.respond_to? :to_str
          keys = []

          # give back '/' when finished compiling, if path end with '/'
          postfix = '/' if path =~ /\/\z/

          segments = path.split('/').map do |segment|
            pattern = segment.to_str

            # Key handling.
            pattern.gsub(/((:\w+)|\*)/) do |match|
              if match == "*"
                keys << 'splat'
                "(.*?)"
              else
                keys << $2[1..-1]
                "([^/?#]+)"
              end
            end
          end
          [/\A#{segments.join('/')}#{postfix}\z/, keys]
        # RegExp
        elsif path.respond_to?(:names) && path.respond_to?(:match)
          [path, path.names]
        # Anything respond_to :match
        elsif path.respond_to?(:match)
          [path, []]
        # Wrong Type
        else
          raise TypeError, path
        end
      end
    end

    reset!

  end

  # Sinatra delegation mixin. Mixing this module into an object causes all
  # methods to be delegated to the Sinatra::Base class. Used primarily
  # at the top-level.
  # Delegator has been rewritten, and it's more like delegate method in Rails.
  module Delegator #:nodoc:
    def self.delegate(*methods, options)
      target = options[:to]
      methods.each do |method_name|
        define_method(method_name) do |*args, &block|
          return super(*args, &block) if respond_to? method_name
          target.send(method_name, *args, &block)
        end
        private method_name
      end
    end

    delegate :get, :patch, :put, :post, :delete, :head, :options, to: Base
  end
end
