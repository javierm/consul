(function() {
  "use strict";
  App.WatchFormChanges = {
    forms: function() {
      return document.querySelectorAll("form[data-watch-changes]");
    },
    msg: function() {
      return document.querySelector("[data-watch-form-message]").dataset.watchFormMessage;
    },
    hasChanged: function() {
      // TODO: use [...App.WatchFormChanges.forms()] or Array.from() in ES6
      return Array.prototype.slice.call(App.WatchFormChanges.forms()).some(function(form) {
        return $(form).serialize() !== form.dataset.watchChanges;
      });
    },
    checkChanges: function(event) {
      if (App.WatchFormChanges.hasChanged() && !confirm(App.WatchFormChanges.msg())) {
        event.preventDefault();
      }
    },
    initialize: function() {
      if (App.WatchFormChanges.forms().length === 0 || App.WatchFormChanges.msg() === undefined) {
        return;
      }
      document.removeEventListener("page:before-change", App.WatchFormChanges.checkChanges);
      document.addEventListener("page:before-change", App.WatchFormChanges.checkChanges);
      App.WatchFormChanges.forms().forEach(function(form) {
        form.dataset.watchChanges = $(form).serialize();
      });
    }
  };
}).call(this);
