module Custom::SearchHelper
  def categories_search_options
    options_for_select(Tag.category.order(:name).map { |i| [i.name, i.name] },
                       params[:advanced_search].try(:[], :tag))
  end
end
