module MapLocationsHelper
  def map_location_available?(map_location)
    map_location.present? && map_location.available?
  end

  def map_location_input_id(map_location, attribute)
    "#{map_location.mappable_type.underscore}_map_location_attributes_#{attribute}".tr("/", "_")
  end

  def render_map(...)
    render Shared::MapLocationComponent.new(...)
  end
end
