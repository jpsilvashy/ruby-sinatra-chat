class Channel
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :created_at, DateTime

  has n, :messages

  def streams
    settings.streams.select { |f| f[:channel] == self.name }
  end
end