require_dependency Rails.root.join("app", "models", "map_location").to_s

class MapLocation
  audited on: [:create, :update, :destroy]
end
