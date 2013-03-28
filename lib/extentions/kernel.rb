class AssertionError < RuntimeError
end

module Kernel
	def assert(cond, message = "Asserion Failed")
		raise AssertionError.new(message) unless cond
	end
	
	def assert_equal(a,b)
		raise AssertionError.new("#{a.inspect} and #{b.inspect} not equal") if a!=b
	end

    def procline(url)
      $0 = "#{@@base_procline ||= $0}:#{url}"
    end 
end