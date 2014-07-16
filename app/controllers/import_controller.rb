#encoding: utf-8

class ImportController < ApplicationController
  def new_web
  	FileUtils.cp params[:web_csv_file].path, "./public/upload/#{Time.now.strftime('%Y%m%d%H%M%S')}.csv"

  	count, created, updated = WebHistory.import_from_csv(params[:web_csv_file].path)

		flash[:notice] = "done, #{count} lines imported, #{created} lines created, #{updated} lines updated"
	  redirect_to '/misc/index'
  end
end
