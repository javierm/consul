class Admin::Poll::Questions::TableActionsComponent < ApplicationComponent
  attr_reader :question
  delegate :can?, to: :helpers

  def initialize(question)
    @question = question
  end

  private

    def actions
      [:edit, :destroy].select do |action|
        can? action, question
      end
    end
end
