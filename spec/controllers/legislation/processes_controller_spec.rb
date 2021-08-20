require "rails_helper"

describe Legislation::ProcessesController do
  let(:legislation_process) { create(:legislation_process, end_date: Date.current - 1.day) }

  it "download excel file test" do
    sign_in(create(:user))
    create(:legislation_question, process: legislation_process, title: "Question 1")

    get :summary, params: { id: legislation_process, format: :xlsx }

    expect(response).to be_success
  end
end
