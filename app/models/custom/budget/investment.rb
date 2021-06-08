require_dependency Rails.root.join('app', 'models', 'budget', 'investment').to_s
# include Custom::BudgetsInvestmentsHelper

class Budget
  class Investment

    scope :by_tag_filter, ->(tag_name) { joins(:tags).where(tags: { kind: 'category' }).tagged_with(tag_name) }

    def self.apply_filters_and_search(_budget, params, current_filter = nil)
      investments = all
      investments = investments.send(current_filter)             if current_filter.present?
      investments = investments.by_heading(params[:heading_id])  if params[:heading_id].present?
      if params[:search].present?
        if params[:search].to_i.positive?
          params[:advanced_search][:id] = params[:search]
        else
          investments = investments.search(params[:search])
        end
      end

      if params[:advanced_search].present?
        investments = investments.by_tag_filter(params[:advanced_search][:tag]) if params[:advanced_search][:tag].present?
        investments = investments.filter(params[:advanced_search].reject{|k,v| k == "tag"}
        )
      end
      investments
    end

    def register_selection_vote_and_unvote(user, vote)
      if vote === "no"
        vote_by(voter: user, vote: vote)
      else
        vote_by(voter: user, vote: vote) if selectable_by?(user)
      end
    end

    def reason_for_not_being_selectable_by(user)
      return permission_problem(user) if permission_problem?(user)
      return :different_heading_assigned unless valid_heading?(user)
      return :max_votes_per_budget_per_user_limit_reached unless user.can_vote_budget_investment_for_this_budget?(self.budget_id)
      return :no_selecting_allowed unless budget.selecting?
    end

    def valid_heading?(user)
      (voted_in?(heading, user) || can_vote_in_another_heading?(user)) &&
      (group_voted_in?(group, user) || can_vote_in_another_group?(user))
    end

    def group_voted_in?(group, user)
      groups_voted_by_user(user).include?(group.id)
    end

    def groups_voted_by_user(user)
      user.votes.for_budget_investments(budget.investments).votables.map(&:group_id).uniq
    end

    def can_vote_in_another_group?(user)
      if has_votes_for_all_region?(user)
        groups_voted_by_user(user).count <= 2
      else
        groups_voted_by_user(user).count <= 1
      end
    end

    def has_votes_for_all_region?(user)
       all_city_group = budget.groups.first # NOTE: First group is all region
      if all_city_group&.headings&.size == 1
        user.votes.for_budget_investments(all_city_group.headings.first.investments).count > 0
      else
        false
      end
    end
  end
end
