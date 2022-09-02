require "rails_helper"
require "cancan/matchers"

describe Abilities::Administrator do
  subject(:ability) { Ability.new(user) }

  let(:user) { administrator.user }
  let(:administrator) { create(:administrator) }

  let(:other_user) { create(:user) }
  let(:hidden_user) { create(:user, :hidden) }

  let(:debate) { create(:debate) }
  let(:comment) { create(:comment) }
  let(:proposal) { create(:proposal, author: user) }
  let(:budget_investment) { create(:budget_investment) }
  let(:finished_investment) { create(:budget_investment, budget: create(:budget, :finished)) }
  let(:legislation_question) { create(:legislation_question) }
  let(:poll) { create(:poll) }
  let(:future_poll) { create(:poll, starts_at: 5.days.from_now) }
  let(:poll_question) { create(:poll_question) }
  let(:future_poll_question) { create(:poll_question, poll: future_poll) }
  let(:current_poll_question_answer) { create(:poll_question_answer) }
  let(:future_poll_question_answer) { create(:poll_question_answer, poll: future_poll) }

  let(:current_poll_answer_video) { create(:poll_answer_video, answer: current_poll_question_answer) }
  let(:future_poll_answer_video) { create(:poll_answer_video, answer: future_poll_question_answer) }

  let(:past_process) { create(:legislation_process, :past) }
  let(:past_draft_process) { create(:legislation_process, :past, :not_published) }
  let(:open_process) { create(:legislation_process, :open) }

  let(:proposal_document) { build(:document, documentable: proposal, user: proposal.author) }
  let(:budget_investment_document) { build(:document, documentable: budget_investment) }
  let(:poll_question_document) { build(:document, documentable: poll_question) }

  let(:proposal_image) { build(:image, imageable: proposal, user: proposal.author) }
  let(:budget_investment_image) { build(:image, imageable: budget_investment) }

  let(:hidden_debate) { create(:debate, :hidden) }
  let(:hidden_comment) { create(:comment, :hidden) }
  let(:hidden_proposal) { create(:proposal, :hidden) }

  let(:dashboard_administrator_task) { create(:dashboard_administrator_task) }

  it { should be_able_to(:index, Debate) }
  it { should be_able_to(:show, debate) }
  it { should be_able_to(:vote, debate) }

  it { should be_able_to(:index, Proposal) }
  it { should be_able_to(:show, proposal) }

  it { should_not be_able_to(:restore, comment) }
  it { should_not be_able_to(:restore, debate) }
  it { should_not be_able_to(:restore, proposal) }
  it { should_not be_able_to(:restore, other_user) }

  it { should be_able_to(:restore, hidden_comment) }
  it { should be_able_to(:restore, hidden_debate) }
  it { should be_able_to(:restore, hidden_proposal) }
  it { should be_able_to(:restore, hidden_user) }

  it { should_not be_able_to(:confirm_hide, comment) }
  it { should_not be_able_to(:confirm_hide, debate) }
  it { should_not be_able_to(:confirm_hide, proposal) }
  it { should_not be_able_to(:confirm_hide, other_user) }

  it { should be_able_to(:confirm_hide, hidden_comment) }
  it { should be_able_to(:confirm_hide, hidden_debate) }
  it { should be_able_to(:confirm_hide, hidden_proposal) }
  it { should be_able_to(:confirm_hide, hidden_user) }

  it { should be_able_to(:comment_as_administrator, debate) }
  it { should_not be_able_to(:comment_as_moderator, debate) }

  it { should be_able_to(:comment_as_administrator, proposal) }
  it { should_not be_able_to(:comment_as_moderator, proposal) }

  it { should be_able_to(:comment_as_administrator, legislation_question) }
  it { should_not be_able_to(:comment_as_moderator, legislation_question) }

  it { should be_able_to(:comment_as_administrator, poll) }
  it { should_not be_able_to(:comment_as_moderator, poll) }

  it { should be_able_to(:summary, past_process) }
  it { should_not be_able_to(:summary, past_draft_process) }
  it { should_not be_able_to(:summary, open_process) }

  it { should be_able_to(:create, Budget) }
  it { should be_able_to(:update, Budget) }

  it { should be_able_to(:read_results, create(:budget, :reviewing_ballots, :with_winner)) }
  it { should be_able_to(:read_results, create(:budget, :finished, :with_winner)) }
  it { should be_able_to(:read_results, create(:budget, :finished, results_enabled: true)) }
  it { should_not be_able_to(:read_results, create(:budget, :balloting, :with_winner, results_enabled: true)) }
  it { should_not be_able_to(:read_results, create(:budget, :reviewing_ballots, results_enabled: true)) }
  it { should_not be_able_to(:read_results, create(:budget, :finished, results_enabled: false)) }

  it { should be_able_to(:calculate_winners, create(:budget, :reviewing_ballots)) }
  it { should_not be_able_to(:calculate_winners, create(:budget, :balloting)) }
  it { should_not be_able_to(:calculate_winners, create(:budget, :finished)) }

  it { should be_able_to(:create, Budget::ValuatorAssignment) }

  it { should be_able_to(:admin_update, Budget::Investment) }
  it { should be_able_to(:hide, Budget::Investment) }

  it { should be_able_to(:valuate, create(:budget_investment, budget: create(:budget, :valuating))) }
  it { should_not be_able_to(:admin_update, finished_investment) }
  it { should_not be_able_to(:valuate, finished_investment) }
  it { should_not be_able_to(:comment_valuation, finished_investment) }
  it { should_not be_able_to(:toggle_selection, finished_investment) }

  it { should be_able_to(:destroy, proposal_image) }
  it { should be_able_to(:destroy, proposal_document) }
  it { should_not be_able_to(:destroy, budget_investment_image) }
  it { should_not be_able_to(:destroy, budget_investment_document) }
  it { should be_able_to(:manage, Dashboard::Action) }

  it { should be_able_to(:read, Poll::Question) }
  it { should be_able_to(:create, future_poll_question) }
  it { should be_able_to(:update, future_poll_question) }
  it { should be_able_to(:destroy, future_poll_question) }
  it { should_not be_able_to(:create, poll_question) }
  it { should_not be_able_to(:update, poll_question) }
  it { should_not be_able_to(:destroy, poll_question) }

  it { should be_able_to(:read, Poll::Question::Answer) }
  it { should be_able_to(:documents, Poll::Question::Answer) }
  it { should be_able_to(:order_answers, Poll::Question::Answer) }
  it { should be_able_to(:create, future_poll_question_answer) }
  it { should be_able_to(:update, future_poll_question_answer) }
  it { should be_able_to(:destroy, future_poll_question_answer) }
  it { should_not be_able_to(:create, current_poll_question_answer) }
  it { should_not be_able_to(:update, current_poll_question_answer) }
  it { should_not be_able_to(:destroy, current_poll_question_answer) }

  it { should be_able_to(:create, future_poll_answer_video) }
  it { should be_able_to(:update, future_poll_answer_video) }
  it { should be_able_to(:destroy, future_poll_answer_video) }

  it { should_not be_able_to(:create, current_poll_answer_video) }
  it { should_not be_able_to(:update, current_poll_answer_video) }
  it { should_not be_able_to(:destroy, current_poll_answer_video) }

  it { is_expected.to be_able_to :manage, Dashboard::AdministratorTask }
  it { is_expected.to be_able_to :manage, dashboard_administrator_task }

  it { should be_able_to(:manage, LocalCensusRecord) }
  it { should be_able_to(:create, LocalCensusRecords::Import) }
  it { should be_able_to(:show, LocalCensusRecords::Import) }

  it { should be_able_to(:read, SDG::Target) }

  it { should be_able_to(:read, SDG::Manager) }
  it { should be_able_to(:create, SDG::Manager) }
  it { should be_able_to(:destroy, SDG::Manager) }

  it { should be_able_to(:manage, Widget::Card) }
end
