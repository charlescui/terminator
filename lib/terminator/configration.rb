require "redis"
require "amqp"
require 'logger'
require 'dalli'
require 'active_support/cache/dalli_store'

class ::Logger; alias_method :write, :<<; end

module Terminator
	module Configration
		class << self
			def config!
				file = File.join(File.dirname(__FILE__), "..", "..", "config","server.yml")
				File.exists?(file) ? YAML.load(File.open file)[ENV["RACK_ENV"]] : {}
			end
			
			def config
				@_config ||= self.config!
			end

			def method_missing(name, *args)
				name && (config[name] || config[name.to_sym])
			end
		end
	end
end

T = Terminator
T::C = Terminator::Configration