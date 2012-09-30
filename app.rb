#!/usr/bin/env ruby -I ../lib -I lib
# coding: utf-8

require 'bundler/setup'
Bundler.require

require 'sinatra'
require 'sinatra/session'

require 'json'
require 'forgery'
require 'geocoder'
require 'ip'
require 'yaml'
require 'sanitize'
require 'data_mapper'

# Settings
set :server, 'thin'
set :session_secret, 'super-secret'
set :protection, :except => :frame_options
set :views, Proc.new { File.join(root, "app/views") }

set :streams, []

# Setup DataMapper
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3::memory:")

# Models
require_relative 'app/models/channel'
require_relative 'app/models/message'

# Finalize DataMapper after initializing models
DataMapper.finalize
DataMapper.auto_upgrade!

# Controllers
require_relative 'app/controllers/base_controller'
require_relative 'app/controllers/channel_controller'
require_relative 'app/controllers/stream_controller'

