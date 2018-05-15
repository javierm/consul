// Overrides and adds customized javascripts in this file
// Read more on documentation:
// * English: https://github.com/consul/consul/blob/master/CUSTOMIZE_EN.md#javascript
// * Spanish: https://github.com/consul/consul/blob/master/CUSTOMIZE_ES.md#javascript
//
//

//= require surveys
//= require cookies_eu
//= require js.cookie
//= require verification_form

var initialize_custom_modules = function() {
  App.Surveys.initialize();
  App.VerificationForm.initialize();
}

$(function(){
  $(document).ready(initialize_custom_modules);
  $(document).on('page:load', initialize_custom_modules);
  $(document).on('ajax:complete', initialize_custom_modules);

  if(window.location.pathname == '/') {
    var video = Cookies.get('video');
    if(video != null) {
      var videoWrapper = $('.highlight .videoWrapper');
      var tutorial = $('iframe.tutorial');
      videoWrapper.html('').append(tutorial);
      Cookies.remove('video');
    } else {
      Cookies.set('video', '1', { expires: 7 });
    }
  }
})
