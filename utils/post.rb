# #!/usr/bin/env ruby -I ../lib -I lib
# # coding: utf-8

require 'httparty'
require 'pp'

base_uri = 'http://localhost:4567'

loop do
  options = {
    channel: 'a1',
    session_id: "some_session_id",
    body: "lorem ipsum"
  }

  # make request
  request = HTTParty.post(base_uri, query: options)
  puts request.response.code

  sleep 1
end
