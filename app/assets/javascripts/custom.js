// Overrides and adds customized javascripts in this file
// Read more on documentation: 
// * English: https://github.com/consul/consul/blob/master/CUSTOMIZE_EN.md#javascript
// * Spanish: https://github.com/consul/consul/blob/master/CUSTOMIZE_ES.md#javascript
//
//

//= require surveys

var initialize_custom_modules = function() {
  App.Surveys.initialize();
}

$(function(){
  $(document).ready(initialize_custom_modules);
  $(document).on('page:load', initialize_custom_modules);
  $(document).on('ajax:complete', initialize_custom_modules);
})
