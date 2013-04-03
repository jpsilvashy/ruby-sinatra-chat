get '/stream/:channel', provides: 'text/event-stream' do
  @channel_name = params[:channel]

  # Open up stream and keep it open
  stream :keep_open do |out|

    # Insert channel into streams
    settings.streams << { channel: @channel_name, out: out }

    # Delete stream
    # FIXME: I don't know how this works
    out.callback do
      settings.streams.delete_if {|hash| hash[@channel_name] == @channel_name}
    end
  end
end
