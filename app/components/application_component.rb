class ApplicationComponent < ViewComponent::Base
  def icon_link_to(text, path, icon:, **options)
    link_to path, options.merge(class: "icon-link") do
      tag.span(data: { tooltip: "", position: "bottom", alignment: "center" }, tabindex: 1, title: text) do
        tag.span(class: icon) + tag.span(text, class: "show-for-sr")
      end
    end
  end
end
