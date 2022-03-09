require_dependency Rails.root.join('app', 'models', 'budget').to_s

class Budget
  remove_const("CURRENCY_SYMBOLS")
  CURRENCY_SYMBOLS = %w[€ $ £ RON].freeze
end
