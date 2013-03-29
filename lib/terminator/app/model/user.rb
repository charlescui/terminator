class User < ActiveRecord::Base
	acts_as_authentic do |c|
		c.validate_email_field = false
		# 禁止自动更新perishable_token
		c.disable_perishable_token_maintenance = true
	end

	acts_as_paranoid
	include Redis::Objects
	
	counter :logincount
	list :tags
end