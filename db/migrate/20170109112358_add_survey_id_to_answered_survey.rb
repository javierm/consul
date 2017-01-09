class AddSurveyIdToAnsweredSurvey < ActiveRecord::Migration
  def change
    add_column :answered_surveys, :survey_id, :integer
  end
end
