require 'sinatra/base'

# extends dsl methods to `main` object without affect object's
# ancestors chain
extend Sinatra::Delegator
