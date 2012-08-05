require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3::memory:")

class Channel
  include DataMapper::Resource

  property :slug        , String, key: true, unique_index: true
  property :created_at  , DateTime
  property :updated_at  , DateTime

  has n, :messages
  # has n, :users
end

class Message
  include DataMapper::Resource

  property :id          , Serial

  property :ip          , String
  property :content     , String
  property :color       , String
  property :created_at  , DateTime

  belongs_to :channel
  # belongs_to :user
end

# class User
#   include DataMapper::Resource

#   property :id        , String, key: true, unique_index: true

#   has n, :messages
# end

DataMapper.auto_migrate!

