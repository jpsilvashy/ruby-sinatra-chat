var channel = window.location.pathname.substr(1);

console.log("channel:", channel);

var event_source = new EventSource("/stream/" + channel);

// Calculate latency of messages
function latency(time) {
  current_time = new Date().getTime().toFixed(3);
  return (current_time - time).toFixed(3);
}

// Handle messages
function handleMessage(message) {

  chat_message = $("<li>");
  chat_message.text(message.content);
  chat_message.css("border-left-color", message.color);

  $('#events').append(chat_message);

  console.log(message, message.color, latency(message.timestamp))
}

// Recieve messages from eventsource, send to handler
event_source.onmessage = function(event) {
  message = JSON.parse(event.data);
  handleMessage(message);
};

event_source.onclose = function(event) {
  console.log("closing connection");
};

$(document).ready(function() {

  $("form").live("submit", function(e) {
    $.post('/', {
      content: $('#message').val(),
      channel: channel,
      color: $('#message').data('color')
    });

    console.log($('#message').val());

    $('#message').val('');
    $('#message').focus();

    e.preventDefault();
  });
});