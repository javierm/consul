(function() {
  "use strict";
  App.SDGTargetListInput = {
    initialize: function() {
      document.querySelectorAll("[data-target-list]").forEach(function(input) {
        var target_list = $(input).data("target-list");

        $(input).autocomplete({
          source: function(request, response) {
            response($.ui.autocomplete.filter(target_list, App.TagAutocomplete.extractLast(request.term)));
          },
          select: function(event, ui) {
            App.TagAutocomplete.select(this, event, ui);
          },
          search: function() {
            return App.TagAutocomplete.extractLast(this.value);
          },
        });
      });
    }
  };
}).call(this);
