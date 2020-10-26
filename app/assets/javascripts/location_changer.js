(function () {
  "use strict";
  App.LocationChanger = {
    initialize: function () {
      $("input[type=radio][name=select-local]").on("change", function () {
        window.location.assign($(this).val());
      });
    },
  };
}.call(this));
