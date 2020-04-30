(function() {
  "use strict";
  App.Menu = {
    initialize: function() {
      $("a[href='#side_menu']").on("click", function(event) {
        event.preventDefault();

        $("#side_menu").toggleClass("has-menu");
      });
    }
  };
}).call(this);
