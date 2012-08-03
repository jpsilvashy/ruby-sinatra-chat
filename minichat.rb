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

  # generate a lol name
  random_name = [
    Forgery::Name.female_first_name,
    Forgery::Basic.color,
    Forgery::Address.street_name.split(" ").first
  ].join("-").downcase

  # redirect to a random fun name!
  redirect random_name
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

  message = {
    channel: channel,
    ip: IP.new(request.ip),
    color: Forgery::Basic.hex_color,
    content: params[:content]
  }

  # do some processing
  channels[channel] << "data: #{message.to_json}\n\n"

  204 # response without entity body
end