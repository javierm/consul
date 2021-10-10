TestProf.configure do |config|
  # the directory to put artifacts (reports) in ('tmp/test_prof' by default)
  config.output_dir = "tmp/test_prof"

  # use unique filenames for reports (by simply appending current timestamp)
  config.timestamps = true

  # color output
  config.color = true

  # where to write logs (defaults)
  config.output = $stdout

  # alternatively, you can specify a custom logger instance
  # config.logger = MyLogger.new
end
