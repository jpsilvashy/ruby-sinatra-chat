var channel = window.location.pathname.substr(1);
var user_id = $('meta[name=user_id]').attr("content");
var new_messages = 0

console.log("channel:", channel);

var event_source = new EventSource("/stream/" + channel);

// Calculate latency of messages
function latency(time) {
  var current_time = new Date().getTime().toFixed(3);
  return (current_time - time).toFixed(3);
}

// Play sound files
function playSound(sound_name) {
  var sound = new Audio("/audio/" + sound_name + ".wav"); // buffers automatically when created
  sound.play()
}

// update title
function set_title(content) {
  $('title').text(content);
}

function flashTitle(title) {
  if ($('title').text() == 'Chattyloo') {
    set_title(title)
  } else {
    set_title('Chattyloo')
  }
}

// Handle messages
function handleMessage(message) {

  chat_message = $("<li>");
  chat_message.text(message.content);
  chat_message.css("border-left-color", message.color);

  $('#events').append(chat_message);

  // if message.session_id ==
  if (user_id == message.user_id) {
    playSound('send');
  } else {
    playSound('recieve');
    new_messages++
    flasher_title_int = self.setInterval("flashTitle('New Message')", 1000);
  }


  // console.log(message, message.color, latency(message.timestamp))
}

// Recieve messages from eventsource, send to handler
event_source.onmessage = function(event) {
  message = JSON.parse(event.data);
  handleMessage(message);
};

event_source.onclose = function(event) {
  console.log("closing connection");
};

function resetForm() {
  $('form textarea').focus().val('');
  $('form textarea').height('45px');
}

$(document).ready(function() {
  $('#message').autosize();
  resetForm();

  // return title of page back to normal
  $(window).bind('keydown click', function() {
    if (new_messages > 0) {
      set_title('Chattyloo');
      window.flasher_title_int = window.clearInterval(flasher_title_int);
    }
    new_messages = 0;
  });

  $('form textarea').bind('keypress', function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if (code == 13) {
      $("form").submit();

      resetForm();
      e.preventDefault();
    }
  });

  $("form").live("submit", function(e) {
    $.post('/', {
      content: $('#message').val(),
      channel: channel,
      color: $('#message').data('color'),
      user_id: $('#message').data('user-id')
    });

    resetForm();
    e.preventDefault();
  });
});