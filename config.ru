require './app'

# required for heroku streaming logs to work
$stdout.sync = true

run Sinatra::Application