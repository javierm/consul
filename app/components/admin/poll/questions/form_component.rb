class Admin::Poll::Questions::FormComponent < ApplicationComponent
  attr_reader :poll, :question, :url

  def initialize(poll, question, url:)
    @poll = poll
    @question = question
    @url = url
  end
end
