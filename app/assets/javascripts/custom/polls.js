(function() {
  "use strict";
  App.Polls.consulReplacetoken = App.Polls.replacetoken;
  App.Polls.replacetoken = function(token) {
    App.Polls.consulReplacetoken(token);
    $(".js-poll-answers-form-token").each(function() {
      if (this.value.length === 0) {
        this.value = token;
      }
    });
  };
}).call(this);
