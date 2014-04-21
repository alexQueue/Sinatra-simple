#require 'bundler'
#Bundler.require
# To use:
# $ irb
# $ require './console.rb'

def development?
  true
end

require './models/models.rb'
require 'sinatra'
require './helpers/helpers'
