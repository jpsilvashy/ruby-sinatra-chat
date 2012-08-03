# #!/usr/bin/env ruby -I ../lib -I lib
# # coding: utf-8

require 'httparty'
require 'pp'

base_uri = 'http://0.0.0.0:4567'

loop do
  options = {
    channel: ARGV[0],
    timestamp: (Time.now.to_f * 1000.0).to_f.round(3)
  }

  # make request
  request = HTTParty.post(base_uri, query: options)
  puts request.response.code

  sleep 1
end
