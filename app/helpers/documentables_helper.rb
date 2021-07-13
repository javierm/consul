module DocumentablesHelper
  def max_file_size(documentable_class)
    documentable_class.max_file_size / Numeric::MEGABYTE
  end

  def accepted_content_types(documentable_class)
    documentable_class.accepted_content_types
  end

  def documentable_humanized_accepted_content_types(documentable_class)
    Setting.accepted_content_types_for("documents").join(", ")
  end
end
