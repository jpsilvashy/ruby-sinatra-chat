#!/usr/bin/env ruby -I ../lib -I lib
# coding: utf-8

require 'bundler/setup'
Bundler.require

require 'sinatra'
require 'sinatra/session'

require 'iron_cache'
require 'json'
require 'ip'
require 'forgery'
require 'yaml'

# Settings
set :server, 'thin'
set :session_secret, 'super-secret'
set :protection, :except => :frame_options

set :ironcache, IronCache::Client.new( token: ENV["IRON_CACHE_TOKEN"], project_id: ENV["IRON_CACHE_PROJECT_ID"] )
set :channel_message_limit, 10

set :streams, []

# Models
require_relative 'models/channel'
require_relative 'models/user'

# Controllers
require_relative 'controllers/base_controller'
require_relative 'controllers/channel_controller'
require_relative 'controllers/stream_controller'

