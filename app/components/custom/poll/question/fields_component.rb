class Poll::Question::FieldsComponent < ApplicationComponent
  attr_accessor :answer, :form, :question
  delegate :current_user, to: :helpers

  def initialize(form, question, answer)
    @form = form
    @question = question
    @answer = answer
  end

  def errors_for(field)
    return unless answer.errors.include?(field)

    tag.small class: "form-error is-visible" do
      answer.errors.full_messages_for(field).join(", ")
    end
  end
end
