require "rails_helper"

describe Budgets::StatsController do
  describe "GET show" do
    it "raises an error if budget slug is not found" do
      expect do
        get :show, params: { budget_id: "wrong_budget" }
      end.to raise_error ActiveRecord::RecordNotFound
    end

    it "raises an error if budget id is not found" do
      expect do
        get :show, params: { budget_id: 0 }
      end.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
