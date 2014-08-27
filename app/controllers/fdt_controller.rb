class FdtController < ApplicationController
  def index
  	@date = params[:date].nil? ? Date.today : Date.parse(params[:date])
  	@fetches = FetchHistory.where('created_at >= ? AND created_at < ?', @date, @date + 1)
  	@tchannels = TChannel.where("status = 1")
  	
  	@loupans = []
  	loupan_ids = WebHistory.find_by_sql(["SELECT loupan_id FROM `web_histories` WHERE riqi BETWEEN ? AND ? GROUP BY loupan_id", @date - 1, @date]).collect{|x| x.loupan_id}
  	@loupans = Loupan.find_by_sql("SELECT id, name, fdd_house_id FROM loupans WHERE id IN (" + loupan_ids.join(", ") + ")") if loupan_ids.size > 0
  	@uploadable = !@loupans.collect{|x| x.fdd_house_id}.include?(0)
  end
  
  def add_csv
  	@created_at = Date.parse(params[:created_at])
  	@source = params[:source]
  	return if !request.post?
  	FileUtils.cp params[:web_csv_file].path, "./public/upload/#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"
  	count, created, updated = WebHistory.import_from_csv(params[:web_csv_file].path)
		flash[:notice] = "done, #{count} lines imported, #{created} lines created, #{updated} lines updated"
		
		fh = FetchHistory.find_or_create_by_source_and_created_at(@source, @created_at)
		fh.status = 10
		fh.save
	  redirect_to :host => "211.144.118.125:9301", :controller => 'fdt', :action => "index", :date => @created_at
	end
	
	def upload
		flash[:notice] = "done"
  	date = Date.parse(params[:udate])
  	WebHistory.upload_to_db(date)
	  redirect_to :host => "211.144.118.125:9301", :controller => 'fdt', :action => "index"
	end
	
  def assign_id
  	@loupan = Loupan.find(params[:id])
  	return if !request.post?
  	
  	@loupan.fdd_house_id = params[:fdd_house_id]
  	@loupan.save
		flash[:notice] = "done"
	end
	
	def channels
  	@tchannels = TChannel.where("status = 1")
	end
	
	def del_channel
		c = TChannel.find(params[:id])
		c.status = 0
		c.save
		redirect_to :host => "211.144.118.125:9301", :controller => 'fdt', :action => "channels"
	end
	
	def add_channel
		render :action => :edit_channel
	end
	
	def edit_channel
		if !params[:id].blank?
			@channel = TChannel.find(params[:id])
		else
			@channel = TChannel.new
		end
  	return if !request.post?
  	@channel.channel_code = params[:channel_code]
  	@channel.channel_name = params[:channel_name]
  	@channel.status = 1
  	@channel.save
		redirect_to :host => "211.144.118.125:9301", :controller => 'fdt', :action => "channels"
	end
	
	def loupan
  	@loupans = Loupan.where(:output_needed => 1)
		
	end
end
