(function() {
  "use strict";
  App.Managers.generatePassword = function() {
    var pass, possible_chars, possible_digits, possible_symbols, password_complexity;
    password_complexity = $(".generate-random-value").data("password-complexity");
    possible_chars = "abcdefghijklmnopqrstuvwxyz";
    possible_digits = "123456789";
    possible_symbols = "-_.,;!?";

    pass = Array.apply(null, {
      length: 8
    }).map(function() {
      var i;
      i = Math.floor(Math.random() * possible_chars.length);
      return possible_chars.charAt(i);
    }).join("");

    for (var i = 0; i < password_complexity.upper; i++) {
      pass += possible_chars.charAt(Math.floor(Math.random() * possible_chars.length)).toUpperCase();
    }

    for (var i = 0; i < password_complexity.digit; i++) {
      pass += possible_digits.charAt(Math.floor(Math.random() * possible_digits.length));
    }

    for (var i = 0; i < password_complexity.symbol; i++) {
      pass += possible_symbols.charAt(Math.floor(Math.random() * possible_symbols.length));
    }

    return pass;
  };
}).call(this);
