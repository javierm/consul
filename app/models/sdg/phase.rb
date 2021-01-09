class SDG::Phase < ApplicationRecord
  enum kind: %w[sensitization planning monitoring]
  validates :kind, presence: true, uniqueness: true
  has_many :cards, class_name: "Widget::Card", as: :page

  def self.[](kind)
    find_by!(kind: kind)
  end

  def title
    self.class.human_attribute_name("kind.#{kind}")
  end
end
