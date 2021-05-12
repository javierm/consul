require_dependency Rails.root.join("app", "models", "widget", "card").to_s

class Widget::Card
  translates :link_url, touch: true
  translates :link_text_2, touch: true
  translates :link_url_2, touch: true
end
