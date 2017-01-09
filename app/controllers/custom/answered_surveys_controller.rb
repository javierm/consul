class AnsweredSurveysController < ApplicationController
  load_and_authorize_resource

  def new
    @survey = Survey.find(params[:survey])
    @survey_questions = @survey.survey_questions
    @answered_survey = AnsweredSurvey.new()
    @survey_questions.count.times { @answered_survey.survey_question_answers.build}
  end

  def create
    @answered_survey = AnsweredSurvey.new(answered_survey_params)
    @answered_survey.user = current_user
    if @answered_survey.save
      redirect_to @answered_survey, notice: I18n.t("flash.actions.create.answered_survey")
    else
      render :new
    end
  end

  def show
    @answered_survey = AnsweredSurvey.find(params[:id])
  end

  private

  def answered_survey_params
    params.require(:answered_survey).permit(:user_id, survey_question_answers_attributes: [:id, :answered_survey, :survey_question_value_id])
  end

end
