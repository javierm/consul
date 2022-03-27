require_dependency Rails.root.join("app", "models", "poll", "answer").to_s

class Poll::Answer
  belongs_to :answer, class_name: "Poll::Question::Answer", inverse_of: :answers

  skip_validation :answer, :presence
  skip_validation :answer, :inclusion

  validates :answer_id, presence: true,
                        if: ->(a) { a.question&.is_single_choice? && a.question.mandatory_answer? }
  validates :answer_id, inclusion: { in: ->(a) { a.question.question_answers.ids }},
                        if: ->(a) { a.question&.is_single_choice? },
                        allow_nil: true
  validates :open_answer, presence: true,
                          unless: ->(a) { a.question&.is_single_choice? },
                          if: ->(a) { a.question&.mandatory_answer? }
end
