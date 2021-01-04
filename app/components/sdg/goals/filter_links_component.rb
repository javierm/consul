class SDG::Goals::FilterLinksComponent < ApplicationComponent
  attr_reader :name, :limit

  def initialize(name)
    @name = name
  end

  def render?
    SDG::ProcessEnabled.new(name).enabled?
  end

  private

    def heading
      t("sdg.goals.filter.heading")
    end
end
