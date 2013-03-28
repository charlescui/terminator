$:.unshift File.dirname(__FILE__)

require "uuid"
require 'kramdown'
require 'ostruct'
require "sinatra/base"
require "sinatra/reloader"
require "better_errors"
require "active_support"
require 'active_support/core_ext/string/inflections'
require "active_support/core_ext/object/blank"

begin
	gem 'eventmachine'
	EM.epoll
	EM.threadpool_size = ::T::C.config[:threads] || 250
rescue Exception => e
	# do nothing
end

Dir[File.join(File.dirname(__FILE__), 'extentions', '*.rb')].each{|file| require_relative file}
Dir[File.join(File.dirname(__FILE__), 'terminator', 'app', 'model', '*.rb')].each{|file| require_relative file}

module Terminator
	def self.env
		@_env ||= ENV["ENV"] || ENV["RACK_ENV"] || "development"
	end

	def self.root
		@_root ||= File.join(File.dirname(File.expand_path(__FILE__)), '..')
	end

	require_relative './terminator/app/controller/application_controller'

	module App
		module Controller
			def self.controllers_url_map
				@@_controllers_url_map ||= {'/' => ApplicationController}
			end
		end#Controller
	end#App
end#Terminator
require_relative "terminator/configration"

Dir[File.join(File.dirname(__FILE__), 'terminator', 'app', 'controller', '*.rb')].each{|file| require_relative file}
