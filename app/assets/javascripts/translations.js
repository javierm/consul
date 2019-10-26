(function() {
  "use strict";
  App.Translations = {
    selected_language: function() {
      return $("#select_language").val();
    },
    display_locale: function(locale) {
      App.Translations.enable_locale(locale);
      App.Translations.add_language(locale);
      $(".js-add-language option:selected").removeAttr("selected");
    },
    display_translations: function(locale) {
      $(".js-select-language option[value=" + locale + "]").prop("selected", true);
      $(".js-translatable-attribute").each(function() {
        if ($(this).data("locale") === locale) {
          $(this).show();
        } else {
          $(this).hide();
        }
        $(".js-delete-language").hide();
        $(".js-delete-" + locale).show();
      });
    },
    add_language: function(locale) {
      var language_option, option;
      language_option = $(".js-add-language [value=" + locale + "]");
      if ($(".js-select-language option[value=" + locale + "]").length === 0) {
        option = new Option(language_option.text(), language_option.val());
        $(".js-select-language").append(option);
      }
      $(".js-select-language option[value=" + locale + "]").prop("selected", true);
    },
    remove_language: function(locale) {
      var next;
      $(".js-translatable-attribute[data-locale=" + locale + "]").each(function() {
        $(this).val("").hide();
        App.Translations.resetEditor(this);
      });
      $(".js-select-language option[value=" + locale + "]").remove();
      next = $(".js-select-language option:not([value=''])").first();
      App.Translations.display_translations(next.val());
      App.Translations.disable_locale(locale);
      App.Translations.update_description();
      if ($(".js-select-language option").length === 1) {
        $(".js-select-language option").prop("selected", true);
      }
    },
    resetEditor: function(element) {
      if (CKEDITOR.instances[$(element).attr("id")]) {
        CKEDITOR.instances[$(element).attr("id")].setData("");
      }
    },
    enable_locale: function(locale) {
      App.Translations.destroy_locale_field(locale).val(false);
      App.Translations.site_customization_enable_locale_field(locale).val(1);
    },
    disable_locale: function(locale) {
      App.Translations.destroy_locale_field(locale).val(true);
      App.Translations.site_customization_enable_locale_field(locale).val(0);
    },
    enabled_locales: function() {
      return $.map($(".js-select-language:first option:not([value=''])"), function(element) {
        return $(element).val();
      });
    },
    destroy_locale_field: function(locale) {
      return $("input[id$=_destroy][data-locale=" + locale + "]");
    },
    site_customization_enable_locale_field: function(locale) {
      return $("#enabled_translations_" + locale);
    },
    refresh_visible_translations: function() {
      var locale;
      locale = $(".js-select-language").val();
      App.Translations.display_translations(locale);
    },
    update_description: function() {
      var count, description;
      count = App.Translations.enabled_locales().length;
      description = $(App.Translations.language_description(count)).filter(".description").text();

      $(".js-languages-description .description").text(description);
      $(".js-languages-description .count").text(count);
    },
    language_description: function(count) {
      switch (count) {
      case 0:
        return $(".translation-languages").data("zero-languages-description");
      case 1:
        return $(".translation-languages").data("one-languages-description");
      default:
        return $(".translation-languages").data("other-languages-description");
      }
    },
    initialize: function() {
      $(".js-add-language").on("change", function() {
        var locale;
        locale = $(this).val();
        App.Translations.display_translations(locale);
        App.Translations.display_locale(locale);
        App.Translations.update_description();
      });
      $(".js-select-language").on("change", function() {
        App.Translations.display_translations($(this).val());
      });
      $(".js-delete-language").on("click", function(e) {
        e.preventDefault();
        App.Translations.remove_language($(this).data("locale"));
        $(this).hide();
      });
      $(".js-add-fields-container").on("cocoon:after-insert", function() {
        App.Translations.enabled_locales().forEach(function(locale) {
          App.Translations.enable_locale(locale);
        });
      });
    }
  };
}).call(this);
