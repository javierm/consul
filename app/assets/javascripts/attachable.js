(function() {
  "use strict";

  App.Attachable = {
    setupInput: function(config) {
      var $input, $container, $fieldsContainer, uploadData, dropzone, $zone, dropzoneOptions;

      $input = $(config.input);
      $fieldsContainer = $input.closest(".nested-fields");
      $container = $input.closest(config.attachmentContainer);
      $zone = $("<div>", { class: "hidden-dropzone-upload" });
      $container.append($zone);

      uploadData = {};

      dropzoneOptions = {
        url: $input.data("url"),
        paramName: "attachment",
        maxFiles: 1,
        clickable: false,
        headers: { "X-CSRF-Token": $("meta[name=csrf-token]").attr("content") },
        previewTemplate: "<div></div>"
      };

      dropzone = new Dropzone($zone[0], dropzoneOptions);

      $input.on("change", function() {
        uploadData = App.Attachable.buildData(config.input);
        App.Attachable.setFilename(uploadData, this.files[0].name);
        dropzone.addFile(this.files[0]);
      });

      dropzone.on("addedfile", function() {
        uploadData = App.Attachable.buildData(config.input);
        App.Attachable.clearProgressBar(uploadData);
        App.Attachable.setProgressBar(uploadData, "uploading");
      });

      dropzone.on("uploadprogress", function(_file, progress) {
        $(uploadData.progressBar).find(".loading-bar").css("width", progress + "%");
      });

      dropzone.on("success", function(_file, response) {
        App.Attachable.setNewContent($fieldsContainer, response, "complete");

        if (config.onSuccess) {
          config.onSuccess($fieldsContainer.find("[type=file]"));
        }

        $fieldsContainer.focus();
      });

      dropzone.on("error", function(file, response) {
        App.Attachable.setNewContent($fieldsContainer, response, "errors");
        var new_input = $fieldsContainer.find("[type=file]");

        if (config.onError) {
          config.onError(new_input);
        }

        new_input.focus();
        dropzone.removeFile(file);
      });
    },
    buildData: function(input) {
      var data, wrapper;

      data = [];
      wrapper = $(input).closest(".direct-upload");

      data.wrapper = wrapper;
      data.progressBar = $(wrapper).find(".progress-bar-placeholder");
      data.fileNameContainer = $(wrapper).find("p.file-name");

      $(wrapper).find(".progress-bar-placeholder").css("display", "block");

      return data;
    },
    clearProgressBar: function(data) {
      $(data.progressBar).find(".loading-bar").removeClass("complete errors uploading").css("width", "0px");
    },
    setFilename: function(data, file_name) {
      $(data.fileNameContainer).text(file_name);
    },
    setProgressBar: function(data, klass) {
      $(data.progressBar).find(".loading-bar").addClass(klass);
    },
    setNewContent: function(fields_container, response, progress_bar_class) {
      fields_container.html($(response.content).html())
        .find(".progress-bar-placeholder").css("display", "block")
        .find(".loading-bar").addClass(progress_bar_class).css("width", "100%");
    }
  };
}).call(this);
