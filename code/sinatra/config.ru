require "rubygems"
require "sinatra"
require "sinatra/static_assets"
require "mongo"
require "haml"

require "./main"
run Sinatra::Application
