// Generated by CoffeeScript 1.12.6
(function() {
  "use strict";
  App.SocialShare = {
    initialize: function() {
      return $(".social-share-button a").each(function() {
        return $(this).append("<span class='show-for-sr'>" + ($(this).data("site")) + "</span>");
      });
    }
  };

}).call(this);
