var channel = window.location.hostname + "-" + window.location.pathname.substr(1);
var event_source = new EventSource("/stream/" + channel);
var session_id = $('meta[name=session_id]').attr("content");

// Handle messages
function handleMessage(message) {

  var color = message.session_id.substring(0, 3);
  var location = $("<span>").text(message.location).addClass('message_location');

  var message = $("<li>").text(message.content).css('borderLeftColor', color);
  var message = message.append(location);

  $('#events').append(message);
}

// Recieve messages from eventsource, send to handler
event_source.onmessage = function(event) {
  message = JSON.parse(event.data);
  handleMessage(message);
};

// Call on close
event_source.onclose = function(event) {
  console.log("closing connection");
};

// Reset form and focus
function resetForm() {
  $('form textarea').focus().val('');
}

function login() {
  // does nothing yet
}

$(document).ready(function() {

  // log user in
  login();

  // Bind enter key to submit form
  $('form').bind('keypress', function(event) {
    var code = (event.keyCode ? event.keyCode : event.which);
    if (code == 13) {
      $("form").submit();
    }
  });

  // Send post request on submit
  $("form").bind('submit', function(event) {

    // FIXME: Find a better way to see if the form has a value, this is broken
    value = $('form textarea').val().replace(/\s+/g, ' ').length

    if (value > 1) {
      $.post('/', {
        channel: channel,
        session_id: session_id,
        content: $('form textarea').val(),
      }, function() {
        resetForm();
      });
    }

    event.preventDefault();
  });
});