require 'rubygems'
$:.unshift '.'

require "pp"
require "./lib/terminator"

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])
Bundler.require(:default, ENV['RACK_ENV'])

pp ::Terminator::App::Controller.controllers_url_map

run Rack::URLMap.new(::Terminator::App::Controller.controllers_url_map)