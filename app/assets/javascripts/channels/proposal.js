(function() {
  "use strict";

  App.proposal = App.cable.subscriptions.create("ProposalChannel", {
    connected: function() {
      // Called when the subscription is ready for use on the server
    },

    disconnected: function() {
      // Called when the subscription has been terminated by the server
    },

    received: function(data) {
      // TODO: do we need to configure ARIA?
      $("#" + data.id).html(data.supports);
    },

    vote: function() {
    }
  });
}).call(this);
