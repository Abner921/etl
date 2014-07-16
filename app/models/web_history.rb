#encoding: utf-8
require 'csv'

class WebHistory < ActiveRecord::Base
	
	def self.import_from_csv(csv_path)

  	count = 0
  	created = 0
  	updated = 0
		CSV.foreach(csv_path, encoding: 'GB18030:utf-8') do |row|
			begin
				if row[0].include?("-")
					nriqi = DateTime.strptime(row[0], "%Y-%m-%d").in_time_zone
					riqi = DateTime.new(nriqi.year, nriqi.month, nriqi.day).in_time_zone
				elsif row[0].include?("/")
					nriqi = DateTime.strptime(row[0], "%Y/%m/%d").in_time_zone
					riqi = DateTime.new(nriqi.year, nriqi.month, nriqi.day).in_time_zone
				else
					nriqi = DateTime.strptime(row[0], "%m月%d日").in_time_zone
					year = nriqi.month == 12 ? 2013 : 2014
					riqi = DateTime.new(year, nriqi.month, nriqi.day).in_time_zone
				end
			rescue
				next
			end

			channel = row[1]
			channel_id = ApplicationController::general_find_or_create_by_name("channel", channel)
			loupan = row[2]
			loupan_id = ApplicationController::general_find_or_create_by_name("loupan", loupan)
			fenlei = row[3]
			fenlei_id = ApplicationController::general_find_or_create_by_name("fenlei", fenlei)
			diyu = row[4]
			diyu_id = ApplicationController::general_find_or_create_by_name("diyu", diyu)
			jihua = row[5]
			jihua_id = ApplicationController::general_find_or_create_by_name("jihua", jihua)
			
			wh = WebHistory.find_by_riqi_and_channel_id_and_loupan_id_and_fenlei_id_and_diyu_id_and_jihua_id(riqi, channel_id, loupan_id, fenlei_id, diyu_id, jihua_id)
			
			if wh.nil?
				wh = WebHistory.new(:riqi => riqi, :channel_id => channel_id, :loupan_id => loupan_id, :fenlei_id => fenlei_id, :diyu_id => diyu_id, :jihua_id => jihua_id)
				created += 1
			else
				updated += 1
			end
			
			cost = row[6]
			impression_count = row[7]
			click_count = row[8]
			
			wh.cost = ApplicationController::normalize_number(cost)
			wh.impression_count = ApplicationController::normalize_number(impression_count)
			wh.click_count = ApplicationController::normalize_number(click_count)
			
#			begin
				wh.save!
				count += 1
#			rescue
#				puts "save error"
#				puts riqi + cost + impression_count + click_counter
#			end
		end
		return [count, created, updated]

	end
	
	def self.upload_to_db(date)
  	channels = [
	  	{"name" => "百度SEM", "channel_ids" => "6", "direct_channel" => 1, "direct_device" => 1}, 
	  	{"name" => "谷歌SEM", "channel_ids" => "5", "direct_channel" => 2, "direct_device" => 1}, 
	  	{"name" => "搜狗SEM", "channel_ids" => "3", "direct_channel" => 4, "direct_device" => 1}, 
	  	{"name" => "360SEM", "channel_ids" => "4", "direct_channel" => 3, "direct_device" => 1}, 
	  	{"name" => "全网联盟", "channel_ids" => "11, 12, 1, 8, 2, 14, 15, 16, 19, 20", "direct_device" => 1}, 
	  	{"name" => "百度移动", "channel_ids" => "7", "direct_channel" => 1, "direct_device" => 2}, 
	  	{"name" => "谷歌移动", "channel_ids" => "17", "direct_channel" => 2, "direct_device" => 2}, 
	  	{"name" => "搜狗移动", "channel_ids" => "9", "direct_channel" => 4, "direct_device" => 2}, 
	  	{"name" => "360移动", "channel_ids" => "18", "direct_channel" => 3, "direct_device" => 2}, 
	  	{"name" => "移动联盟", "channel_ids" => "10, 13", "direct_device" => 2}
		]

		house_ids = WebHistory.find_by_sql(["SELECT loupans.fdd_house_id FROM `loupans` JOIN web_histories ON loupans.id = web_histories.loupan_id WHERE web_histories.riqi BETWEEN ? AND ? GROUP BY loupans.fdd_house_id", date - 1, date]).delete_if {|x| x.fdd_house_id == 0}.collect{|x| x.fdd_house_id}

		db = DirectDB.new
		for house_id in house_ids
			loupan_ids = Loupan.find_all_by_fdd_house_id(house_id).collect{|x| x.id}
			
			for channel in channels
				sem = WebHistory.find_by_sql(["SELECT riqi, SUM(cost) AS cost, SUM(impression_count) AS impression_count, SUM(click_count) AS click_count FROM `web_histories` WHERE `channel_id` IN (#{channel["channel_ids"]}) AND `loupan_id` IN (#{loupan_ids.join(', ')}) AND riqi BETWEEN ? AND ? GROUP BY loupan_id", date - 1, date])

				if !house_id.nil? and sem.size > 0
					cost = sem[0].cost * 5
					impression_count = sem[0].impression_count
					click_count = sem[0].click_count
					
					if channel["name"] == "全网联盟" or channel["name"] == "移动联盟"
						db.insert_direct_history(house_id, date - 1, 21, channel["direct_device"], (cost * 0.1).round, (impression_count * 0.1).round, (click_count * 0.1).round)
						db.insert_direct_history(house_id, date - 1, 22, channel["direct_device"], (cost * 0.5).round, (impression_count * 0.5).round, (click_count * 0.5).round)
						db.insert_direct_history(house_id, date - 1, 23, channel["direct_device"], (cost * 0.4).round, (impression_count * 0.4).round, (click_count * 0.4).round)
					else
						db.insert_direct_history(house_id, date - 1, channel["direct_channel"], channel["direct_device"], cost, impression_count, click_count)
					end
				end
			end
		end
		
	end
end
