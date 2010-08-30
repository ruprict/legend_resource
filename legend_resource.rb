#!/usr/bin/ruby
require 'rubygems'
require 'sinatra'
require 'arcserver'
require './lib/backends/gstore_legend'
require './lib/backends/fileutils_legend'

class LegendResource < Sinatra::Base

  set :filehandler, File 
		
	get '/legend/:server/*' do
		generate_legend_image do |image| 
		  settings.filehandler.write(image,legend_image_filename) 
    end unless settings.filehandler.exists?(legend_image_filename)
		settings.filehandler.send(legend_image_filename)
	end
	
	delete '/legend/:server/*' do
	  if settings.filehandler.exists?(legend_image_filename)
	    settings.filehandler.delete(legend_image_filename)
	    status 200
    else
      status 204
    end
	end
  
  private
	
	def service_path
	  params[:splat].first
	end
	
	def generate_legend_image
	  image = ArcServer::MapServer.new("http://#{params[:server]}/ArcGIS/services/#{service_path}/MapServer").get_legend_image
	  yield image
	  image.destroy!
	end
	
	def legend_image_filename
	  "#{params[:server]}_#{service_path.split('/').join('_')}.png"
	end
	
	
end
