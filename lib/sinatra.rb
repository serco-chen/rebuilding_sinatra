# Include lib directory to load path, so require will
# perform like gem's require_path specified.
$:.unshift "#{File.dirname(__FILE__)}"

require 'sinatra/base'
require 'sinatra/main'
