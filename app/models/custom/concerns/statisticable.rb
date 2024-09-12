load Rails.root.join("app", "models", "concerns", "statisticable.rb")

module Statisticable
  def gender?
    participants.male.any? || participants.female.any? || participants.other_gender.any?
  end

  def total_other_gender_participants
    participants.other_gender.count
  end

  def other_gender_percentage
    calculate_percentage(total_other_gender_participants, total_participants_with_gender)
  end
end
