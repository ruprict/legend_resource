require 'rubygems'
require 'bundler'

Bundler.setup
#require 'rmagick'
require 'sinatra'
require './legend_resource'

run LegendResource
