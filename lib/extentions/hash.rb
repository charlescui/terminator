class Hash
	def string_keys
		tmp = self.dup
		tmp.clear
		self.keys.each do |k|
			tmp[k.to_s] = self[k]
		end
		tmp
	end

end
