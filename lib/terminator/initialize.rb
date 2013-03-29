# initialize log
Dir.mkdir('log') unless File.exist?(File.join(Terminator.root, 'log'))

# Set rack environment
ENV['RACK_ENV'] ||= "development"

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

# initialize ActiveRecord
require 'active_record'

ActiveRecord::Base.establish_connection YAML::load_file(File.join(Terminator.root, 'config', 'database.yml'))[ENV["RACK_ENV"]]
ActiveRecord::Base.logger = $logger

# initialize ActiveSupport
require 'active_support'

ActiveSupport.on_load(:active_record) do
  self.include_root_in_json = false
  self.default_timezone = :local
  self.time_zone_aware_attributes = false
  self.logger = $logger
  # self.observers = :cacher, :garbage_collector, :forum_observer
end

# initialize redis
$redis = Redis.connect(:url => ::T::C.redis)
# initialize amqp
# $amqp = AMQP.connect(:host => ::T::C.amqp)

# initialize cache
require 'dalli'
Dalli.logger = $logger
$cache = Dalli::Client.new(*::T::C.cache, :namespace => "Terminator::#{ENV["RACK_ENV"]}", :expires_in => 3600*24)

require 'redis-objects'
Redis::Objects.redis = $redis

require "authlogic"
require "rails3_acts_as_paranoid"