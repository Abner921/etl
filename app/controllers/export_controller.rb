#encoding: utf-8
require "spreadsheet"

class ExportController < ApplicationController
  def download
  	
  	channels = [["百度SEM", "6", 0, 0], ["谷歌SEM", "5", 0, 0], ["360SEM", "4", 0, 0], ["搜狗SEM", "3", 0, 0], ["全网联盟", "11, 12, 1, 8, 2, 14, 15, 16, 19, 20", 0, 0], ["百度移动", "7", 4, 2], ["谷歌移动", "17", 4, 2], ["360移动", "18", 4, 2], ["搜狗移动", "9", 4, 2], ["移动联盟", "10, 13", 4, 2]]
  	@files = []
  	
  	loupans = Loupan.where(:output_needed => 1)
  	
  	for loupan in loupans

#			loupan = Loupan.find(2)

	  	Spreadsheet.client_encoding = "UTF-8"
			book = Spreadsheet::Workbook.new
			sheet1 = book.create_worksheet :name => '基础数据'
			sheet2 = book.create_worksheet :name => '投入管理'
			sheet1.merge_cells(0, 0, 3, 0)
			sheet1[0, 0] = '日期'
			sheet1.merge_cells(0, 1, 0, 14)
			sheet1[0, 1] = 'PC端'
			sheet1.merge_cells(0, 15, 0, 28)
			sheet1[0, 15] = '移动端'

			sheet1.merge_cells(1, 1, 1, 8)
			sheet1[1, 1] = 'SEM'
			sheet1.merge_cells(1, 9, 1, 14)
			sheet1[1, 9] = '全网联盟'
			sheet1.merge_cells(1, 15, 1, 22)
			sheet1[1, 15] = 'SEM'
			sheet1.merge_cells(1, 23, 1, 28)
			sheet1[1, 23] = '全网联盟'

			sheet1.merge_cells(2, 1, 2, 2)
			sheet1[2, 1] = '百度'
			sheet1.merge_cells(2, 3, 2, 4)
			sheet1[2, 3] = '谷歌'
			sheet1.merge_cells(2, 5, 2, 6)
			sheet1[2, 5] = '360'
			sheet1.merge_cells(2, 7, 2, 8)
			sheet1[2, 7] = '搜狗'

			sheet1.merge_cells(2, 9, 2, 10)
			sheet1[2, 9] = '重定向'
			sheet1.merge_cells(2, 11, 2, 12)
			sheet1[2, 11] = '人群定向'
			sheet1.merge_cells(2, 13, 2, 14)
			sheet1[2, 13] = '网站定向'

			sheet1.merge_cells(2, 15, 2, 16)
			sheet1[2, 15] = '百度'
			sheet1.merge_cells(2, 17, 2, 18)
			sheet1[2, 17] = '谷歌'
			sheet1.merge_cells(2, 19, 2, 20)
			sheet1[2, 19] = '360'
			sheet1.merge_cells(2, 21, 2, 22)
			sheet1[2, 21] = '搜狗'

			sheet1.merge_cells(2, 23, 2, 24)
			sheet1[2, 23] = '重定向'
			sheet1.merge_cells(2, 25, 2, 26)
			sheet1[2, 25] = '人群定向'
			sheet1.merge_cells(2, 27, 2, 28)
			sheet1[2, 27] = '网站定向'
			
			(0..13).each { |i|
				sheet1[3, i * 2 + 1] = '展示'
				sheet1[3, i * 2 + 2] = '点击'
			}

			sheet2.merge_cells(0, 0, 2, 0)
			sheet2[0, 0] = '日期'
			sheet2.merge_cells(0, 1, 0, 7)
			sheet2[0, 1] = 'PC端'
			sheet2.merge_cells(0, 8, 0, 14)
			sheet2[0, 8] = '移动端'

			sheet2.merge_cells(1, 1, 1, 4)
			sheet2[1, 1] = 'SEM'
			sheet2.merge_cells(1, 5, 1, 7)
			sheet2[1, 5] = '全网联盟'
			sheet2.merge_cells(1, 8, 1, 11)
			sheet2[1, 8] = 'SEM'
			sheet2.merge_cells(1, 12, 1, 14)
			sheet2[1, 12] = '全网联盟'

			sheet2[2, 1] = '百度'
			sheet2[2, 2] = '谷歌'
			sheet2[2, 3] = '360'
			sheet2[2, 4] = '搜狗'
			sheet2[2, 5] = '重定向'
			sheet2[2, 6] = '人群定向'
			sheet2[2, 7] = '网站定向'

			sheet2[2, 8] = '百度'
			sheet2[2, 9] = '谷歌'
			sheet2[2, 10] = '360'
			sheet2[2, 11] = '搜狗'
			sheet2[2, 12] = '重定向'
			sheet2[2, 13] = '人群定向'
			sheet2[2, 14] = '网站定向'

			
			riqis = WebHistory.find_by_sql("SELECT riqi FROM `web_histories` WHERE `loupan_id` = #{loupan.id} GROUP BY riqi ORDER BY riqi").collect{|x| x.riqi}
			
			channels.each_with_index { |channel, c_index|
				sem = WebHistory.find_by_sql("SELECT riqi, SUM(cost) AS cost, SUM(impression_count) AS impression_count, SUM(click_count) AS click_count FROM `web_histories` WHERE `channel_id` IN (#{channel[1]}) AND `loupan_id` = #{loupan.id} GROUP BY riqi ORDER BY riqi")
				sem_result = ApplicationController::format_result_by_riqis(sem, riqis)
				
				riqis.each_with_index { |riqi, index|
					riqi_str = Date.new(riqi.year, riqi.month, riqi.day).to_s
					riqi = riqi.to_s
					
					impression_count = (!sem_result[riqi].nil? and sem_result[riqi].size > 0) ? sem_result[riqi][0].impression_count : 0
					
					click_count = (!sem_result[riqi].nil? and sem_result[riqi].size > 0) ? sem_result[riqi][0].click_count : 0
					cost = (!sem_result[riqi].nil? and sem_result[riqi].size > 0) ? sem_result[riqi][0].cost : 0
					
					if c_index == 0
			      sheet1[4 + index, channel[2] + 0 + c_index * 2] = riqi_str 
			      sheet2[3 + index, 0 + c_index] = riqi_str
		      end
		      
		      sheet1[4 + index, channel[2] + 1 + c_index * 2] = impression_count
		      sheet1[4 + index, channel[2] + 2 + c_index * 2] = click_count

		      sheet2[3 + index, channel[3] + 1 + c_index] = cost

		      if channel[0] == '全网联盟'
			      sheet1[4 + index, 9] = (impression_count * 0.1).round
			      sheet1[4 + index, 10] = (click_count * 0.1).round
			      sheet1[4 + index, 11] = (impression_count * 0.5).round
			      sheet1[4 + index, 12] = (click_count * 0.5).round
			      sheet1[4 + index, 13] = (impression_count * 0.4).round
			      sheet1[4 + index, 14] = (click_count * 0.4).round

			      sheet2[3 + index, 5] = (cost * 0.1)
			      sheet2[3 + index, 6] = (cost * 0.5)
			      sheet2[3 + index, 7] = (cost * 0.4)
	      	end

		      if channel[0] == '移动联盟'
			      sheet1[4 + index, 23] = (impression_count * 0.1).round
			      sheet1[4 + index, 24] = (click_count * 0.1).round
			      sheet1[4 + index, 25] = (impression_count * 0.5).round
			      sheet1[4 + index, 26] = (click_count * 0.5).round
			      sheet1[4 + index, 27] = (impression_count * 0.4).round
			      sheet1[4 + index, 28] = (click_count * 0.4).round

			      sheet2[3 + index, 12] = (cost * 0.1)
			      sheet2[3 + index, 13] = (cost * 0.5)
			      sheet2[3 + index, 14] = (cost * 0.4)
	      	end

				}
			}
      			
	    book.write "./public/#{loupan.name}.xls"
	    @files << "#{loupan.name}.xls"
	    
    end

  	@loupans = Loupan.where(:output_needed => 1)
		flash[:notice] = 'done'
	  render '/misc/index'
  end
  
  def upload
  	WebHistory.upload_to_db(Date.today)
  	@loupans = Loupan.where(:output_needed => 1)
		flash[:notice] = 'done'
	  render '/misc/index'
	end
	
end
