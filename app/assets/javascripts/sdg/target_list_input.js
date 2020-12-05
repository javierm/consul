(function() {
  "use strict";
  App.SDGTargetListInput = {
    initialize: function() {
      document.querySelectorAll("[data-target-list]").forEach(function(input) {
        $(input).autocomplete({
          source: $(input).data("target-list")
        });
      });
    }
  };
}).call(this);
