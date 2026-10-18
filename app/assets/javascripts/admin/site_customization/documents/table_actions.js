(function() {
  "use strict";
  App.AdminSiteCustomizationDocumentsTableActions = {
    initialize: function() {
      $(".admin .site-customization-documents-table-actions .copy-link-link").on("click", function() {
        navigator.clipboard.writeText($(this).data("url"));
      });
    }
  };
}).call(this);

