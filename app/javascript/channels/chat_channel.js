import consumer from "channels/consumer"

consumer.subscriptions.create("ChatChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    $('#dummy_message')
    .clone()
    .text(data['message'])
    .appendTo($('#messages'));
  },
  send_message: function(data) {
    this.perform('send_message', { message: data });
  }
  // send_message: function() {
  //   return this.perform('send_message');
  // }
});
