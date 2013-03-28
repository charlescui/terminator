module Terminator
	module App
		module Controller
			class Home < ApplicationController
				get '/' do
					# 如果是Web Service，约定返回数据结构如下
					{:status => 0, :msg => 'ok', :data => [1,2,3]}
				end
			end
		end
	end
end