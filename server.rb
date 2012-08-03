#!/usr/bin/env ruby -I ../lib -I lib
# coding: utf-8
require 'sinatra'
require 'json'
require 'ip'
require 'forgery'

set :server, 'thin'

channels = {}
chatters = []

get '/' do
  erb :index, locals: { channels: channels }
end

get '/:channel' do
  channel = params[:channel]
  puts "=> get / [#{channel}]"

  erb :channel
end

get '/stream/:channel', provides: 'text/event-stream' do
  channel = params[:channel]
  puts "=> get /stream/:channel [#{channel}]"

  stream :keep_open do |out|
    channels[channel] = out
    out.callback { channels[channel].delete(out) }
  end
end

post '/' do
  channel = params[:channel]
  puts "=> post / [#{channel}]"
  puts "=> params #{params}"

  ip = IP.new(request.ip)

  # create color for user based off IP address
  params[:color] = ip.to_hex[0..-3]

  nickname = [Forgery::Basic.color, Forgery::Address.street_name.split(" ").first, rand(100)].join("-").downcase

  # if chatter
    # puts "this guy has been here!"
  # else
    chatter = {
      channel: channel,
      ip: ip,
      color: params[:color],
      nickname: nickname
    }

    chatters << chatter

  # end

  # puts chatter

  # puts "=> chatters:"
  # puts chatters

  # do some processing
  channels[channel] << "data: #{params.to_json}\n\n"

  204 # response without entity body
end