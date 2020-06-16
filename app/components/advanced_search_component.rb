class AdvancedSearchComponent < ApplicationComponent
  attr_reader :search_path

  def initialize(search_path)
    @search_path = search_path
  end

  private

    def official_level_search_options
      options_for_select((1..5).map { |i| [setting["official_level_#{i}_name"], i] },
                         advanced_search_terms[:official_level])
    end

    def date_range_options
      options_for_select([
        [t("shared.advanced_search.date_1"), 1],
        [t("shared.advanced_search.date_2"), 2],
        [t("shared.advanced_search.date_3"), 3],
        [t("shared.advanced_search.date_4"), 4],
        [t("shared.advanced_search.date_5"), "custom"]],
        selected_date_range)
    end

    def selected_date_range
      date_max.present? ? "custom" : date_min
    end

    def date_min
      advanced_search_terms[:date_min]
    end

    def date_max
      advanced_search_terms[:date_max]
    end

    def advanced_search_terms
      params[:advanced_search] || {}
    end
end
