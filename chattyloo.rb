#!/usr/bin/env ruby -I ../lib -I lib
# coding: utf-8

require 'sinatra'
require 'sinatra/session'

require 'json'
require 'ip'
require 'forgery'

require_relative 'dm'

set :server, 'thin'
set :session_secret, 'super-secret'
set :protection, :except => :frame_options

channels = []
chatters = []

get '/' do
  erb :index
end

get '/random' do

  # generate a lol name
  random_name = [
    Forgery::Name.female_first_name,
    Forgery::Basic.color,
    Forgery::Address.street_name.split(" ").first
  ].join("-").downcase

  # redirect to a random fun name!
  redirect random_name
end

get '/status' do
  'OK'
end

get '/:channel' do
  params[:channel]
  puts "=> get / [#{params[:channel]}]"

  # start session
  session_start!
  session[:color] = Forgery::Basic.hex_color

  # get channel from db
  @current_channel = Channel.first_or_create({ slug: params[:channel] })

  puts "=> [get] Channel first: #{@current_channel}"

  erb :channel, locals: { session: session }
end

get '/stream/:channel', provides: 'text/event-stream' do
  channel = params[:channel]
  puts "=> get /stream/:channel [#{channel}]"

  stream :keep_open do |out|

    # insert stream into channels
    channels << { channel: channel, out: out }

    # delete channel
    out.callback do
      puts "=> delete channel"
      # channels.delete_if {|hash| hash[channel] == channel}
    end
  end
end

post '/' do
  channel = params[:channel]
  puts "=> post / [#{channel}]"
  puts "=> params #{params}"

  current_channel = Channel.first_or_create({ slug: channel })
  puts "=> [post] Channel first: #{current_channel.messages.count}"

  # form message
  message = {
    channel: channel,

    user_id: params[:user_id],
    ip: IP.new(request.ip),
    color: params[:color],
    content: params[:content]
  }

  # insert needed records
  current_channel.messages.create({
    # user_id: params[:user_id],
    ip: IP.new(request.ip),
    color: params[:color],
    content: params[:content]
  })

  # Get channels that match the channel name.
  active_channels = channels.select {|f| f[:channel] == channel }

  active_channels.each do |chn|
    chn[:out] << "data: #{message.to_json}\n\n"
  end

  204 # response without entity body
end