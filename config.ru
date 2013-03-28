require "pp"
require "./lib/terminator"
if Terminator.env == 'development'
	require "ruby-debug"
end

pp ::Terminator::App::Controller.controllers_url_map

run Rack::URLMap.new(::Terminator::App::Controller.controllers_url_map)