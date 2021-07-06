class RemoveTextsFromMiddleCards < ActiveRecord::Migration[5.1]
  def change
    Widget::Card.where(middle: true).update(title: nil, description: nil, title_es: nil, title_val: nil, description_es: nil, description_val: nil)
  end
end
