#!/usr/bin/env ruby -I ../lib -I lib
# coding: utf-8

require 'sinatra'
require 'json'
require 'ip'
require 'forgery'

set :server, 'thin'

channels = []
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

    # insert stream into channels
    channels << { channel: channel, out: out }

    # delete channel
    out.callback do
      puts "=> closing channels:"
      puts channels.delete_if {|hash| hash[channel] == channel}
    end
  end
end

post '/' do
  channel = params[:channel]
  puts "=> post / [#{channel}]"
  puts "=> params #{params}"

  # form message
  message = {
    channel: channel,
    ip: IP.new(request.ip),
    color: Forgery::Basic.hex_color,
    content: params[:content]
  }

  # Get channels that match the channel name.
  # FIXME:
  # This implementation does not currently work
  # because the channels array gets clobbered when
  # a new request is made to a different channel.
  # This probably needs a real persistance layer,
  # not 100% sure though.
  channels = channels.select {|f| f[:channel] == channel }

  # write to all channels
  channels.each do |channel|
    channel[:out] << "data: #{message.to_json}\n\n"
  end

  204 # response without entity body
end