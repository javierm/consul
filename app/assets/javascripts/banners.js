(function() {
  "use strict";
  App.Banners = {
    initialize: function() {
      $("[data-js-banner-title]").on({
        change: function() {
          document.getElementById("js-banner-title").innerHTML = this.value;
        }
      });
      $("[data-js-banner-description]").on({
        change: function() {
          document.getElementById("js-banner-description").innerHTML = this.value;
        }
      });
      $("[name='banner[background_color]']").on({
        change: function() {
          document.getElementById("js-banner-background").style.backgroundColor = this.value;
        }
      });
      $("[name='banner[font_color]']").on({
        change: function() {
          document.getElementById("js-banner-title").style.color = this.value;
          document.getElementById("js-banner-description").style.color = this.value;
        }
      });
    }
  };
}).call(this);
