require 'bundler/setup'

# Automatically load all the gems that are specified in the Gemfile, instead of
# requiring them one by one.
Bundler.require(:default, ENV['RACK_ENV'])

##
# Gems

require 'sinatra/base'

require 'jwt'
require 'json'

# Add the Sinatra middleware for Rollbar to properly log the request payload
require 'rollbar/middleware/sinatra'

require 'app/models/version'


##
# Libraries
#
# Remember that order matters!
require 'app/models/payload'
require 'app/api'