class User
  include DataMapper::Resource

  property :id, Serial
  property :ip_address, String
  property :created_at, DateTime

  # has n, :messages
end