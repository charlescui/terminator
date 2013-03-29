require "virtus"

# RdsBase模型是基于redis作为数据库的简洁ORM模型
class RdsBase
	include Virtus
	attribute :id, String, :default => proc{UUID.generate.gsub("-",'')}

	# 根据ID查找对象
	def self.find(id)
		key = self.redis_key(id)
		h = $redis.hgetall(key)
		h && self.new(h)
	end

	def self.del(id)
		key = self.redis_key(id)
		$redis.del(key)
	end

	def del
		self.class.del(self.id)
	end

	# 删除某一属性
	def del_attr(attrt)
		key = self.redis_key(id)
		self.attributes[attrt.to_sym] = nil
		$redis.hdel(key, attrt.to_s)
	end

	# 删除某一属性并保存
	def del_attr!(attrt)
		$redis.multi do
			self.del_attr(attrt)
			self.save
		end
	end

	# 查找某个模型所有实例数据
	def self.all
		keys = $redis.keys("#{self.prefix_redis_key}::*")
		items = $redis.multi do
			keys.map do |key|
				$redis.hgetall(key)
			end
		end
		items.map{|item|self.new(item)}.compact
	end

	# 判断某个模型的某条数据是否存在
	def self.exists(id)
		$redis.exists self.redis_key(id)
	end

	def exists
		self.class.exists(self.id)
	end

	# 保存数据
	def save
		$redis.hmset(self.redis_key, *self.attributes)
	end

	# 保存在内存中的Key
	def redis_key
		self.class.redis_key(self.id)
	end

	def self.redis_key(id)
		"#{self.prefix_redis_key}::#{id}"
	end

	def self.prefix_redis_key
		"Model::#{self.to_s.demodulize}"
	end
end