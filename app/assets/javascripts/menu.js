(function() {
  "use strict";
  App.Menu = {
    initialize: function() {
      $("[href='#side_menu'], [href='#hide_side_menu']").on("click", function(event) {
        event.preventDefault();

        $("#side_menu").toggleClass("has-menu");
      });
    }
  };
}).call(this);
