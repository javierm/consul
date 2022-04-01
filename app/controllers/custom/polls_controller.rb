require_dependency Rails.root.join("app", "controllers", "polls_controller").to_s

class PollsController < ApplicationController
  include GuestUsers
  before_action :set_answers, only: [:answer, :show]
  before_action :set_questions, only: [:answer, :show]
  before_action :set_question_answers, only: [:answer, :show]
  before_action :set_token, only: [:answer, :show]
  before_action :set_commentable, only: [:answer, :show]

  invisible_captcha only: [:answer], honeypot: :title

  def show
  end

  def answer
    if @poll_answers.map(&:valid?).all?(true)
      ActiveRecord::Base.transaction do
        @poll_answers.each do |answer|
          answer.save_and_record_voter_participation(answers_params[:token])
        end
      end
      redirect_to @poll, notice: t("polls.answers.create.success_notice")
    else
      render :show
    end
  end

  private

    def set_commentable
      @commentable = @poll
      @comment_tree = CommentTree.new(@commentable, params[:page], @current_order)
    end

    def set_token
      @token = poll_voter_token(@poll, current_user)
    end

    def set_questions
      @questions = @poll.questions.for_render.sort_for_list
    end

    def set_question_answers
      @poll_questions_answers = Poll::Question::Answer.where(question: @poll.questions)
        .with_content.order(:given_order)
    end

    def set_answers
      @poll_answers = @poll.questions.order(:created_at).each_with_object([]) do |question, answers|
        answer = Poll::Answer.find_or_initialize_by(question: question, author: current_user)
        answer.assign_attributes(answer_params_by(question)) if answer_params_by(question).present?
        answers << answer
      end
    end

    def answers_params
      params.permit(:token, answers_attributes)
    end

    def answer_params_by(question)
      answers_params["question_#{question.id}"]
    end

    def answers_attributes
      @poll.questions.each_with_object({}) do |question, attributes|
        attributes["question_#{question.id}"] = %i[answer_id open_answer]
      end
    end
end
