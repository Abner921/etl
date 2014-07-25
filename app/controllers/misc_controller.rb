class MiscController < ApplicationController
  def index
  	@loupans = Loupan.where(:output_needed => 1)
  	@fetches = FetchHistory.where('created_at >= ? AND created_at < ?', Date.today, Date.tomorrow)
  end
  
  def fetch
  	@fetches = FetchHistory.limit(100).order("created_at DESC")
	end
	
	def upload
		filepath = "/home/fengkan/hades/upload/upload/#{params[:file].original_filename}"

  	FileUtils.cp params[:file].path, filepath
		FileUtils.chmod 0755, filepath

  	render :nothing => true
	end
end
