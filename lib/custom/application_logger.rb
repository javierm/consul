require_dependency Rails.root.join("lib", "application_logger").to_s

class ApplicationLogger
  def warn(message)
    logger.warn(message) unless Rails.env.test?
  end

  def error(message)
    logger.error(message) unless Rails.env.test?
  end
end
