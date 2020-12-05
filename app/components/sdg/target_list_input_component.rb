class SDG::TargetListInputComponent < ApplicationComponent
  attr_reader :f

  def initialize(form)
    @f = form
  end

  def target_list
    SDG::Target.all.sort.map do |target|
      {
        label: "#{target.code}. #{target.title}",
        value: target.code
      }
    end
  end
end
