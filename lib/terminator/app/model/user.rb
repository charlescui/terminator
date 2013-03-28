require_relative './base'

module Terminator
	module App
		module Model
			class User < Base
				attribute :name, String
				# 用户身份认证的token
				attribute :credentials, String

				# 访问token
				def user_credentials
					self.credentials || self.generate_credentials
				end

				# 生成并保存credentials
				def generate_credentials
					self.credentials = UUID.generate.gsub('-','')
					::T::C.redis.multi do
						::T::C.redis.hset("Login::Credentials", credentials, self.id)
						self.save
					end
					self.credentials
				end

				# 重置这个token
				def reset_crendentials
					::T::C.redis.multi do
						::T::C.redis.hdel("Login::Credentials", credentials)
						self.del_attr
						self.save
					end
				end

				# 通过credentials找到某个用户
				def self.find_by_credentials(credentials)
					uid = ::T::C.redis.hget("Login::Credentials", credentials)
					uid && self.find(uid)
				end
			end
		end
	end
end