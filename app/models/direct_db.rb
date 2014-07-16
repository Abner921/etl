require 'digest' 
require 'csv'

class DirectDB

  attr_accessor :db
  
  def initialize()
		self.db = Mysql2::Client.new(:host => '127.0.0.1', :username => 'root', :password=> '', :database => 'fdd_direct', :port => 3306)
  end
  
  def get_house_id(house_name)
  	results = db.query("SELECT house_id FROM t_house WHERE house_name = '#{house_name}'")
  	result = results.first
  	
  	if !result.nil?
  		return result["house_id"]
		else
			return nil
		end
	end
  
  def insert_direct_history(house_id, direct_date, direct_channel, direct_device, direct_devotion_num, direct_show_num, direct_click_num)

  	table_id = Digest::MD5.hexdigest(house_id.to_s)[-2, 2]

  	results = db.query("REPLACE INTO t_house_direct_#{table_id} (house_id, direct_date, direct_channel, direct_device, direct_show_num, direct_click_num, direct_create_time) VALUES (#{house_id}, '#{direct_date}', #{direct_channel}, #{direct_device}, #{direct_show_num}, #{direct_click_num}, '#{Time.now}')")

  	results = db.query("REPLACE INTO t_house_direct_#{table_id} (house_id, direct_date, direct_channel, direct_device, direct_create_time, direct_type, direct_devotion_num) VALUES (#{house_id}, '#{direct_date}', #{direct_channel}, #{direct_device}, '#{Time.now}', 2, #{direct_devotion_num})")

		CSV.open("#{house_id}_#{table_id}.csv", "a+") do |csv|
		  csv << [house_id, direct_date, direct_channel, direct_device, direct_show_num, direct_click_num, "", 1, 0]
		  csv << [house_id, direct_date, direct_channel, direct_device, 0, 0, "", 2, direct_devotion_num]
		end
	end
	
end
