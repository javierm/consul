class SDG::TargetListInputComponent < ApplicationComponent
  attr_reader :f

  def initialize(form)
    @f = form
  end

  def target_list
    goals.map do |goal|
      [goal, *goal.targets.sort]
    end.flatten.map do |goal_or_target|
      {
        label: "#{goal_or_target.code}. #{goal_or_target.title}",
        value: goal_or_target.code
      }
    end
  end

  private

    def goals
      SDG::Goal.order(:code)
    end
end
