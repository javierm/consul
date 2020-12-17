module Abilities
  class Legislator
    include CanCan::Ability

    def initialize(user)
      can :create, Legislation::Proposal
      can :show, Legislation::Proposal, user_id: user.id
      can :proposals, ::Legislation::Process

      can :restore, Legislation::Proposal, user_id: user.id
      cannot :restore, Legislation::Proposal, hidden_at: nil

      can :confirm_hide, Legislation::Proposal, user_id: user.id
      cannot :confirm_hide, Legislation::Proposal, hidden_at: nil

      can :comment_as_administrator, [Legislation::Question, Legislation::Annotation]
      can :comment_as_administrator, [Legislation::Proposal], user_id: user.id

      can [:read, :debate, :draft_publication, :allegations, :result_publication,
          :milestones], Legislation::Process, user_id: user.id
      can [:create], Legislation::Process
      can [:update, :destroy], Legislation::Process, user_id: user.id
      can [:manage], ::Legislation::DraftVersion
      can [:manage], ::Legislation::Question
      can [:manage], ::Legislation::Proposal, user_id: user.id
      cannot :comment_as_moderator, [::Legislation::Question, Legislation::Annotation, ::Legislation::Proposal]
    end
  end
end
