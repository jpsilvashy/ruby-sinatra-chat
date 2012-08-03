#!/usr/bin/env ruby -I ../lib -I lib
# coding: utf-8

require 'sinatra'
require 'json'
require 'ip'
require 'forgery'

require_relative 'dm'

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
  params[:channel]
  puts "=> get / [#{params[:channel]}]"

  erb :channel
end

get '/stream/:channel', provides: 'text/event-stream' do
  channel = params[:channel]
  puts "=> get /stream/:channel [#{channel}]"

  stream :keep_open do |out|

    # insert stream into channels
    channels << { channel: channel, out: out }
    Channel.first_or_create({ slug: channel })

    # delete channel
    out.callback do
      puts channels.delete_if {|hash| hash[channel] == channel}
    end

    puts "=> channels:"
    puts channels
    puts
  end
end

post '/' do
  channel = params[:channel]
  puts "=> post / [#{channel}]"
  puts "=> params #{params}"

  # get proper channel
  active = channels.detect {|f| f[:channel] == channel }

  # get from db too
  chan = Channel.get(channel)

  puts "=> dm channel"
  puts chan.messages.create({ content: params[:content] })
  puts "=> messages on chan: #{chan.messages.count}"

  # Not working.
  # chan.messages.each do |msg|
  #   active[:out] << "data: #{{content: msg.content}.to_json}\n\n"
  # end

  # form message
  message = {
    channel: channel,
    ip: IP.new(request.ip),
    color: Forgery::Basic.hex_color,
    content: params[:content]
  }

  active[:out] << "data: #{message.to_json}\n\n"

  # Get channels that match the channel name.
  # FIXME:
  # This implementation does not currently work
  # because the channels array gets clobbered when
  # a new request is made to a different channel.
  # This probably needs a real persistance layer,
  # not 100% sure though.

  204 # response without entity body
end