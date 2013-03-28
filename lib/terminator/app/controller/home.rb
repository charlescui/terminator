module Terminator
	module App
		module Controller
			class Home < ApplicationController
				configure do
					set :connections, []
				end

				get '/' do
					# 如果是Web Service，约定返回数据结构如下
					{:status => 0, :msg => 'ok', :data => [1,2,3]}
				end

				get '/async' do
					stream :keep_open do |out|
						settings.connections.each do |another|
							another << "Someone comming."
						end
						# 将连接保存起来
						settings.connections << out
						# 当连接中断的时候，将该连接从池中删除
						out.callback{settings.connections.delete(out)}

						out << Time.now.to_s
						EventMachine.add_timer(10){
							out << Time.now.to_s
							out.close
						}
					end
				end
			end
		end
	end
end