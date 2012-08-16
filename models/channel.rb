class Channel

  attr_accessor :name, :messages

  def initialize(name, messages = [])
    @name = name
    @messages = messages
  end

  # Find a channel by channel name
  def self.find(name)
    @name = name
    @messages = JSON.parse(settings.ironcache.cache(@name).get('messages').value)

    Channel.new(@name, @messages)
  end

  # Find a channel by channel name, otherwise create a new one
  def self.find_or_initialize(name)
    if settings.ironcache.cache(name).get('messages').nil?
      self.new(name)
    else
      self.find(name)
    end
  end

  # Inserts a new message into the channel
  def insert(message)
    self.messages.unshift message
    self.messages = self.messages.first(settings.channel_message_limit)
    self.save
  end

  # Save channel
  def save
    settings.ironcache.cache(self.name).put('messages', messages.to_json)
    self
  end

  # Find open streams
  def streams
    settings.streams.select { |f| f[:channel] == self.name }
  end


end
