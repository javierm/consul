class Shared::ModerationActionsComponent < ApplicationComponent
  attr_reader :record
  delegate :can?, to: :helpers

  def initialize(record)
    @record = record
  end

  def render?
    can?(:hide, record) || can?(:hide, record.author)
  end

  private

    def hide_path
      polymorphic_path([:moderation, record], action: :hide)
    end

    def separator
      if record.is_a?(Comment)
        "&nbsp;&bull;&nbsp;"
      else
        "&nbsp;|&nbsp;"
      end
    end
end
