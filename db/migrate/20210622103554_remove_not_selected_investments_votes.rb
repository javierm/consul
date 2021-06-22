class RemoveNotSelectedInvestmentsVotes < ActiveRecord::Migration[5.1]
  def change
    Vote.where(votable_type: 'Budget::Investment', votable_id: Budget::Investment.where(feasibility: :not_selected)).destroy_all
    Budget::Investment.where(feasibility: 'not_selected').each(&:update_cached_votes)
  end
end
