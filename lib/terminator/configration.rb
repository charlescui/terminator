require "redis"
require "amqp"
require 'logger'

module Terminator
	module Configration
		class << self
			def config!
				file = File.join(File.dirname(__FILE__), "..", "..", "config","server.yml")
				File.exists?(file) ? YAML.load(File.open file) : {}
			end
			
			def config
				@config ||= self.config!
			end
			
			def redis
				@redis ||= Redis.connect(:url => config[:redis])
			end

			def amqp
				@amqp ||= AMQP.connect(:host => config[:amqp])
			end

			def method_missing(name, *args)
				name && (config[name] || config[name.to_sym])
			end

			def logger
				return $logger unless $logger
				# initialize log
				Dir.mkdir('log') unless File.exist?(File.join(Terminator.root, 'log'))
				class ::Logger; alias_method :write, :<<; end

				case ENV["RACK_ENV"]
				when "production"
					$logger = ::Logger.new(File.join(Terminator.root, "log/production.log"))
					$logger.level = ::Logger::WARN
				when "development"
					$logger = ::Logger.new(STDOUT)
					$logger.level = ::Logger::DEBUG
				else
					$logger = ::Logger.new("/dev/null")
				end
			end
		end
	end
end

T = Terminator
T::C = Terminator::Configration