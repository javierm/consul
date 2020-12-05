// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require jquery_ujs
//= require jquery-ui/widgets/datepicker
//= require jquery-ui/i18n/datepicker-ar
//= require jquery-ui/i18n/datepicker-bs
//= require jquery-ui/i18n/datepicker-cs
//= require jquery-ui/i18n/datepicker-da
//= require jquery-ui/i18n/datepicker-de
//= require jquery-ui/i18n/datepicker-el
//= require jquery-ui/i18n/datepicker-es
//= require jquery-ui/i18n/datepicker-fa
//= require jquery-ui/i18n/datepicker-fr
//= require jquery-ui/i18n/datepicker-gl
//= require jquery-ui/i18n/datepicker-he
//= require jquery-ui/i18n/datepicker-hr
//= require jquery-ui/i18n/datepicker-id
//= require jquery-ui/i18n/datepicker-it
//= require jquery-ui/i18n/datepicker-nl
//= require jquery-ui/i18n/datepicker-pl
//= require jquery-ui/i18n/datepicker-pt-BR
//= require jquery-ui/i18n/datepicker-ru
//= require jquery-ui/i18n/datepicker-sl
//= require jquery-ui/i18n/datepicker-sq
//= require jquery-ui/i18n/datepicker-sv
//= require jquery-ui/i18n/datepicker-zh-CN
//= require jquery-ui/i18n/datepicker-zh-TW
//= require jquery-ui/i18n/datepicker-en-GB
//= require jquery-ui/widgets/autocomplete
//= require jquery-ui/widgets/sortable
//= require jquery-fileupload/basic
//= require foundation
//= require turbolinks
//= require ahoy
//= require annotator
//= require ckeditor/loader
//= require ckeditor/config
//= require cocoon
//= require initial
//= require leaflet
//= require markdown-it
//= require social-share-button
//= require app
//= require_tree .
//= stub dashboard_graphs
//= stub stat_graphs
//= stub stats

var initialize_modules = function() {
  "use strict";

  App.Answers.initialize();
  App.Questions.initialize();
  App.Comments.initialize();
  App.Users.initialize();
  App.Votes.initialize();
  App.AllowParticipation.initialize();
  App.Tags.initialize();
  App.FoundationExtras.initialize();
  App.LocationChanger.initialize();
  App.CheckAllNone.initialize();
  App.IeAlert.initialize();
  App.AdvancedSearch.initialize();
  App.RegistrationForm.initialize();
  App.Suggest.initialize();
  App.Forms.initialize();
  App.ValuationBudgetInvestmentForm.initialize();
  App.EmbedVideo.initialize();
  App.FixedBar.initialize();
  App.Banners.initialize();
  App.SocialShare.initialize();
  App.CheckboxToggle.initialize();
  App.MarkdownEditor.initialize();
  App.HTMLEditor.initialize();
  App.LegislationAdmin.initialize();
  App.Legislation.initialize();
  if ($(".legislation-annotatable").length) {
    App.LegislationAnnotatable.initialize();
  }
  App.TreeNavigator.initialize();
  App.Documentable.initialize();
  App.Imageable.initialize();
  App.TagAutocomplete.initialize();
  App.SDGTargetListInput.initialize();
  App.PollsAdmin.initialize();
  App.Map.initialize();
  App.Polls.initialize();
  App.Sortable.initialize();
  App.TableSortable.initialize();
  App.InvestmentReportAlert.initialize();
  App.SendNewsletterAlert.initialize();
  App.Managers.initialize();
  App.Globalize.initialize();
  App.SendAdminNotificationAlert.initialize();
  App.Settings.initialize();
  if ($("#js-columns-selector").length) {
    App.ColumnsSelector.initialize();
  }
  App.BudgetEditAssociations.initialize();
  App.Datepicker.initialize();
};

var destroy_non_idempotent_modules = function() {
  "use strict";

  App.ColumnsSelector.destroy();
  App.Datepicker.destroy();
  App.HTMLEditor.destroy();
  App.LegislationAnnotatable.destroy();
  App.Map.destroy();
  App.SocialShare.destroy();
};

$(document).on("turbolinks:load", initialize_modules);
$(document).on("turbolinks:before-cache", destroy_non_idempotent_modules);
