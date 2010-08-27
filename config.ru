require 'rubygems'
require 'bundler'
require 'rmagick'
Bundler.setup

require 'sinatra'
require 'legend_resource'
run LegendResource
