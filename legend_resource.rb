require 'rubygems'
require 'sinatra'
require 'arcserver'

class LegendResource < Sinatra::Base
	
	get '/legend/:server/:folder/:mapservice' do
		create_legend
	end
	
	get '/legend/:server/:mapservice' do
		create_legend
	end
	
	delete '/legend/:server/:folder/:mapservice' do
	  delete_legend
  	end
  	
  	delete '/legend/:server/:mapservice' do
	  delete_legend
  	end
	
	
	private
	
	def create_legend
		url, filename = get_url_and_filename
		puts url
	    if (!File.exists?(filename))
	      mapserver = ArcServer::MapServer.new(url)
	      
	      img = mapserver.get_legend_image
	      img.write(filename)
	    end
	    send_file(filename,:type=>"image/png")
	end
	
	def delete_legend
		url, filename = get_url_and_filename
	    if (File.exists?(filename))
	      File.delete(filename)
	      status 200 
	    else
	      status 204
	    end
	end
	
	def get_url_and_filename
		server = params[:server]
		mapservice = params[:mapservice]
		if params[:folder].nil?
		  folder=nil
		else
		  folder = params[:folder] + "/"
		end
		url = "http://#{server}/ArcGIS/services/#{folder}#{mapservice}/MapServer"
		
		filename="public/images/#{server}_#{mapservice}.png"
		[url,filename]
	end
end