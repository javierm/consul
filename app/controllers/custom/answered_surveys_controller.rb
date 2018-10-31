class AnsweredSurveysController < ApplicationController
  load_and_authorize_resource :survey
  load_and_authorize_resource :answered_survey, through: :survey

  def new
    # User can answer survey once
    if answer_survey = @survey.answer_for(current_user)
      @answered_survey = answer_survey
      redirect_to [@survey, @answered_survey], notice: I18n.t("flash.actions.new.already_answered_survey")
    end
    @questions = @survey.questions.order(:code)
    @questions.each do |question|
      ans = @answered_survey.answers.new
      ans.question = question
    end
  end

  def create
    @answered_survey.user = current_user
    if @answered_survey.save
      redirect_to [@survey, @answered_survey], notice: I18n.t("flash.actions.create.answered_survey")
    else
      render :new
    end
  end

  def show
  end

  private
  def answered_survey_params
    params.require(:answered_survey).permit(:user_id, :survey_id, answers_attributes: [:id, :answered_survey, :survey_question_value_id, :survey_question_id, :comment])
  end

end
