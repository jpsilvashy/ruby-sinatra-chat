get '/:channel' do
  session_start!

  # Form channel name
  channel_name = "#{request.host}-#{params[:channel]}"
  puts "get uri: #{channel_name}"

  # Get the current channel
  @channel = Channel.first_or_create({ name: channel_name })

  erb :channel
end

post '/' do

  # Get the current channel
  @channel = Channel.first_or_create({ name: params[:channel] })
  @location = Geocoder.search(request.ip).first.data['city']

  content = Sanitize.clean(params[:content], Sanitize::Config::RESTRICTED)
  content = content[0..512]

  message = @channel.messages.new({
    session_id: params[:session_id],
    content: content,
    ip_address: request.ip,
    location: @location.length > 0 ? @location : 'Unknown'
  })

  if @channel.save

    # Get open streams which match this channel
    @channel.streams.each do |stream|
      stream[:out] << "data: #{message.to_json}\n\n"
    end

  else
    raise "Message is invalid"
  end

 # Response without entity body
  204
end