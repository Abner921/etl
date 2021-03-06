class LoupanController < ApplicationController
  def delete
  	loupan = Loupan.find(params[:id])
  	loupan.output_needed = 0
  	loupan.save
  	redirect_to :host => "211.144.118.125:9301", :controller => "fdt", :action => "loupan"
  end
  
  def add
  	@loupans = Loupan.find_all_by_output_needed(0, :order => "id DESC")
	end
	
	def add_output
  	loupan = Loupan.find(params[:id])
  	loupan.output_needed = 1
  	loupan.save
  	redirect_to :host => "211.144.118.125:9301", :controller => "fdt", :action => "loupan"
	end
	
	def list
  	@loupans = Loupan.where(:output_needed => 1)
	end
end
