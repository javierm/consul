class SDG::TargetListInputComponent < ApplicationComponent
  attr_reader :f

  def initialize(form)
    @f = form
  end

  def target_list
    SDG::Goal.order(:code).map do |goal|
      [goal, *goal.targets.sort]
    end.flatten.map do |goal_or_target|
      {
        label: "#{goal_or_target.code}. #{goal_or_target.title}",
        value: goal_or_target.code
      }
    end
  end
end
