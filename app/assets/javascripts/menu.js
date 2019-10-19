(function() {
  "use strict";
  App.Menu = {
    initialize: function() {
      $("a[href='#side_menu']").on("click", function(event) {
        var parent, content, wrapper;

        event.preventDefault();
        event.stopPropagation();

        parent = $("#side_menu").parent().addClass("has-menu");
        content = $("#side_menu").next();
        wrapper = $("<div class='has-menu-wrapper'></div>");

        wrapper.on("click", function(e) {
          e.stopPropagation();

          parent.removeClass("has-menu");
          $(this).remove();
        });

        content.prepend(wrapper);
      });
    }
  };
}).call(this);
