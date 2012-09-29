class Message
  include DataMapper::Resource

  property :id, Serial
  property :content, String
  property :location, String
  property :session_id, String, length: 64
  property :ip_address, IPAddress
  property :created_at, DateTime

  belongs_to :channel
  # belongs_to :user
end