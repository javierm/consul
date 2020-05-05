$(function() {
  "use strict";
  $(document).on("page:before-unload", function() {
    App.HTMLEditor.destroy();
  });

  $(document).on("page:restore", function() {
    App.HTMLEditor.initialize();
  });
});
