require 'bundler'
Bundler.require

require File.expand_path('../config/environment',  __FILE__)
require 'json'
require 'byebug'

run TrafficSpy::Server
