class Geography < ApplicationRecord
  validates :name, presence: true
  validates :color, presence: true
  validates :geojson, geojson_format: true

  has_many :headings, class_name: "Budget::Heading", dependent: :nullify

  def outline_points
    normalized_coordinates.map { |longlat| [longlat.last, longlat.first] }
  end

  private

    def normalized_coordinates
      if geojson.present?
        if geojson.match(/"coordinates"\s*:\s*\[{4}/)
          coordinates.reduce([], :concat).reduce([], :concat)
        elsif geojson.match(/"coordinates"\s*:\s*\[{3}/)
          coordinates.reduce([], :concat)
        end
      else
        []
      end
    end

    def coordinates
      JSON.parse(geojson)["geometry"]["coordinates"]
    end
end
