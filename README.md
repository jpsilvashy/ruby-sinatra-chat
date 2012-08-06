Chattyloo
=========

[![Build Status](https://secure.travis-ci.org/rails/rails.png?branch=master)](http://travis-ci.org/rails/rails)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/jpsilvashy/chattyloo)

[Chattyloo](http://chattyloo.com) is an asynchronous chat app written in Sinatra and persisted with Postgres or SQLite using Datamapper. There is no authentication scheme. Users arrive at the index and are redirected to a chat room with a unique URL that can be shared for others to join the room.

It makes use of Server-Sent Events (SSEs) over WebSockets for simplicity.

Besides the fact that it's very simple, the app does have a few bells and whistles. Firstly, different sounds play when chat messages are sent and received. Hearts and :)'s are automatically rotated using CSS3 transforms. Lastly, the title element displays a status message when new messages are received.

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
