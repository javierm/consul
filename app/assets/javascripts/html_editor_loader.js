//= require ckeditor/loader
//= require_directory ./ckeditor
//= require html_editor

$(document).on("turbolinks:before-cache", App.HTMLEditor.destroy);
