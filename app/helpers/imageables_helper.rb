module ImageablesHelper
  def can_destroy_image?(imageable)
    imageable.image.present? && can?(:destroy, imageable.image)
  end

  def imageable_max_file_size
    Setting["uploads.images.max_size"].to_i
  end

  def imageable_accepted_content_types
    Setting["uploads.images.content_types"]&.split(" ") || ["image/jpeg"]
  end

  def imageable_humanized_accepted_content_types
    Setting.accepted_content_types_for("images").join(", ")
  end
end
