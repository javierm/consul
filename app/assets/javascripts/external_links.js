(function() {
  "use strict";

  App.ExternalLinks = {
    initialize: function() {
      $("body").on("click", "a[href]", function(event) {
        var message, url, link_is_external;

        message = document.documentElement.dataset.warningForExternalLinks;

        url = new URL(event.target.href);
        link_is_external = url.origin !== window.location.origin && url.protocol !== "mailto:";

        return link_is_external && message && confirm(message);
      });

      document.addEventListener("click", this.handler, true);
    }
  };
}).call(this);
