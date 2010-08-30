require 'rubygems'
require 'bundler'

Bundler.setup
#require 'rmagick'
require 'sinatra'
require './legend_resource'

run LegendResource
# Uncomment this line to use Google Storage (don't forget to change the gstore.yml file)')
#LegendResource.set :filehandler, GStoreLegend
