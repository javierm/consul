(function() {
  "use strict";
  App.TagAutocomplete = {
    split: function(val) {
      return val.split(/,\s*/);
    },
    extractLast: function(term) {
      return App.TagAutocomplete.split(term).pop();
    },
    select: function(input, event, ui) {
      var terms;

      event.preventDefault();
      event.stopPropagation();

      terms = App.TagAutocomplete.split(input.value);
      terms.pop();
      terms.push(ui.item.value);
      terms.push("");
      input.value = terms.join(", ");
    },
    init_autocomplete: function() {
      $(".tag-autocomplete").autocomplete({
        source: function(request, response) {
          $.ajax({
            url: $(".tag-autocomplete").data("js-url"),
            data: {
              search: App.TagAutocomplete.extractLast(request.term)
            },
            type: "GET",
            dataType: "json",
            success: function(data) {
              return response(data);
            }
          });
        },
        minLength: 0,
        search: function() {
          return App.TagAutocomplete.extractLast(this.value);
        },
        focus: function() {
          return false;
        },
        select: function(event, ui) {
          App.TagAutocomplete.select(this, event, ui);
        }
      });
    },
    initialize: function() {
      App.TagAutocomplete.init_autocomplete();
    }
  };
}).call(this);
