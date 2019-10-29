class ActivePoll < ApplicationRecord
  include Measurable

  extend Mobility
  translates :description, touch: true
  include Translatable
end
