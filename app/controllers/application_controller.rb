#encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :auth_within_fdt

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
	
	def auth_within_fdt
#		f = File.open("dddeeee", 'a')
#		f.write(request.inspect)
#		f.close
		return if request.original_url.include?("/misc/upload")

		redirect_to "http://www.fangdd.com" if request.referer.blank? or (!request.referer.include?("114.215.200.214") and !request.referer.include?("JeeSite") and !request.referer.include?("211.144.118.125"))
	end
end
