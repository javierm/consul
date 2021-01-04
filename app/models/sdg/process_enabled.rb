class SDG::ProcessEnabled
  include SettingsHelper
  attr_reader :record_or_name

  def initialize(record_or_name)
    @record_or_name = record_or_name
  end

  def enabled?
    feature?("sdg") && feature?(process_name) && setting["sdg.process.#{process_name}"]
  end

  def model
    if record_or_name.respond_to?(:downcase)
      record_or_name.constantize
    else
      record_or_name.class
    end
  end

  private

    def process_name
      if module_name == "Legislation"
        "legislation"
      else
        module_name.constantize.table_name
      end
    end

    def module_name
      model.name.split("::").first
    end
end
