#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery

	def self.general_find_or_create_by_name(class_name, name)
		m = eval("#{class_name.capitalize}.find_or_create_by_name('#{name}')")
		return m.id
	end
	
	def self.normalize_number(num)
		return (num.nil? or num.blank? or num.strip() == '-') ? 0 : num.delete(',').delete('?').delete('￥').to_f
	end
	
	def self.format_result_by_riqis(result, riqis)
		r_result = {}
		for riqi in riqis
			r_result[riqi.to_s] = result.select{|r| r["riqi"] == riqi}
		end
		return r_result
	end
end
