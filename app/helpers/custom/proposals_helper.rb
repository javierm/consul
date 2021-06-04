module Custom::ProposalsHelper
  def budget_phase_selecting?
    Budget.find(1).phase == "selecting"
  end
end
