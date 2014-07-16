class MiscController < ApplicationController
  def index
  	@loupans = Loupan.where(:output_needed => 1)
  	@fetches = FetchHistory.where('created_at >= ? AND created_at < ?', Date.today, Date.tomorrow)
  end
  
  def fetch
  	@fetches = FetchHistory.limit(100).order("created_at DESC")
	end
end
