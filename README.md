Chattyloo
=========

A mini asynchronous chat app written with Sinatra and persisted with Postgres or SQLite using Datamapper. There is not authentication scheme. Users arrive at the index and are redirected to a chat room with a unique URL that can be shared for others to join the room.

### Usage

First clone the repository:

``` sh
git clone git@github.com:jpsilvashy/chattyloo.git
```

Run the `bundle` command at the root of the project:

``` sh
cd chattyloo/
bundle
```

Then you should be able to start the server:

``` sh
./chattyloo.rb
```

Then just go to [localhost:4567](http://localhost:4567), and start chatting!

### Deploying to Heroku

You can deploy your own chattyloo app! Here are the instructions for deploying to [Heroku](http://heroku.com).

First in the root creat a new heroku app:

``` sh
heroku apps:create mychatapp
```

Then add the addon for the shared database, this will create a Postgres database with all the proper environment variables needed to connect to it.

``` sh
heroku addons:add shared-database
```

Now deploy the app to the server and go check it out

``` sh
git push heroku master
```
