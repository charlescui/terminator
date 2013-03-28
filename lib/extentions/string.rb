class String	
	
	def tmpl(hash)
	  SimpleTemplate.new.format_string(self, hash)
	end	
	
	def integer?
		self =~ /^[\d]+$/
	end
	
  # 截取字符串
  def trunc(size=5)
    if self.size > size
      self[0..size]+'...'
    else
      self
    end
  end

end

class SimpleTemplate 
  SIMPLE_TEMPLATE_MATCH = /(\\\\)?\{\{([^\}]+)\}\}/
  
  def format_string(string, values={})
    string.gsub(SIMPLE_TEMPLATE_MATCH) do
      escaped, pattern, key = $1, $2, $2.to_sym

      if escaped
        pattern
      elsif !values.include?(key)
        raise ArgumentError.new("key: #{key} should be in #{values.inspect}")
      else
        values[key].to_s
      end
    end
  end
end
