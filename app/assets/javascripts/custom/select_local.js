document.addEventListener('turbolinks:load', function(event) {
  $("input[type=radio][name=select-local]").on("change", function () {
    window.location.assign($(this).val());
  });
});
