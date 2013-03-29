require 'active_record'

module Terminator
	module App
		module Controller
			class RequireUserException < RuntimeError; end
			class ApplicationController < Sinatra::Base
				# 每个子类继承ApplicationController时，会自动生成路由地址
				def self.inherited(subclass)
					super
					subclass_path = subclass.to_s.gsub('Terminator::App::Controller::', '').underscore
					subclass.class_eval{
						# 每个controller对应的view在BASEVIEWPATH目录下
						# 以controller为子目录名，包含了所需要的每个erb模板文件
						set :views,  "#{BASEVIEWPATH}/#{subclass_path}"
					}
					# 每个controller对应的url路径为该controller的类名（如果有模块，模块为url目录的前缀）
			    	Controller.controllers_url_map["/#{subclass_path}"] = subclass
				end

				helpers do
					## 通过单点登录认证方式获得当前登录用户
					def current_user_session
						return @current_user_session if defined?(@current_user_session)
						@current_user_session = UserSession.find
					end

					def current_user
						return @current_user if defined?(@current_user)
						@current_user = current_user_session && current_user_session.record
					end

					def require_user
						unless current_user
							halt 500, {:status => -1, :msg => "need auth first!"}.to_json
							return false
						end
					end

					def authenticate
						authenticate_or_request_with_http_basic do |username, password|
							username == 'terminator' && password == 'password'
						end
					end

					def require_websocket
						halt not_found if !request.websocket?
					end

	    			# 重定义erb模板方法，默认带上全局统一的模板文件
	    			# alias :raw_erb :erb
	    			def perb(template, options={}, locals={})
	    				options = {:layout => (@@_layout ||= IO.read(settings.layout))}.merge options
	    				erb(template, options, locals)
	    			end

	    			def read_me
	    				@@_read_me ||= IO.read(File.join(BASEPATH, 'README.md'))
	    			end
				end

				# 前置过滤器
				before do
					procline(request.path_info)
				end

				BASEPATH = Terminator.root
				# 设置视图文件目录
    			BASEVIEWPATH = "#{BASEPATH}/lib/terminator/app/view"
    			set :views, BASEVIEWPATH
    			set :layout, File.join(BASEVIEWPATH, 'layout.erb')
				
				if respond_to? :public_folder
					set :public_folder, "#{BASEPATH}/public"
				else
					set :public, "#{BASEPATH}/public"
				end
				set :static, true

				# release thread current connection return to connection pool in multi-thread mode
				use ActiveRecord::ConnectionAdapters::ConnectionManagement

				configure :production, :development do
					require 'rack/session/dalli'
					use Rack::Session::Dalli, :cache => $cache
			    	enable :logging
			    end

			    configure :development do
			    	register Sinatra::Reloader
			    	also_reload __FILE__
					use BetterErrors::Middleware
					BetterErrors.application_root = BASEPATH
			    end

			    not_found do
					perb :"404", :views => BASEVIEWPATH
				end

				error do
			    	perb :"500", :views => BASEVIEWPATH
				end

				# 首页内容由README.md文件的markdown语法生成
				get	'/' do
					@@_read_html ||= Kramdown::Document.new(read_me).to_html
				end
			end#ApplicationController
		end
	end
end
