# Homepage
get '/' do
  erb :index
end

# Embed instructions
get '/embed' do
  erb :embed
end

# Status page for pings
get '/status' do
  'OK'
end

# Send user to a random room
get '/random' do

  random_name = [
    Forgery::Name.female_first_name,
    Forgery::Basic.color,
    Forgery::Address.street_name.split(" ").first
  ].join("-").downcase

  redirect random_name
end
