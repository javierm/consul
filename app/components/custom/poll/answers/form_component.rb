class Poll::Answers::FormComponent < ApplicationComponent
  attr_accessor :answers, :poll, :token
  delegate :current_user, to: :helpers

  def initialize(poll, token, answers)
    @poll = poll
    @token = token
    @answers = answers
  end

  def questions
    poll.questions.order(:created_at)
  end

  def question_answer(question)
    answers.find { |answer| answer.question == question }
  end

  def error_message
    count = answers.select { |a| a.errors.any? }.map(&:errors).flatten.count

    I18n.t("polls.answers.form.error", count: count) if count > 0
  end
end
