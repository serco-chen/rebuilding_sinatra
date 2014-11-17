require 'sinatra/base'

module Sinatra

  # Using Kernel#at_exit to run self
  # I'm not a fan of at_exit, but what so ever,
  # Sinatra use it, MiniTest use it, Capybara use it.
  at_exit { Base.run! if $!.nil? }
end

# extends dsl methods to `main` object without affect object's
# ancestors chain
extend Sinatra::Delegator
