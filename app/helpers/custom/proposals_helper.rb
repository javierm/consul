module Custom::ProposalsHelper
  def budget_phase_selecting?
    Budget.find_by(phase: "selecting").present?
  end
end
