module Abilities
  class Common
    include CanCan::Ability

    def initialize(user)
      self.merge Abilities::Everyone.new(user)

      can [:read, :update], User, id: user.id

      can :read, Debate
      # can :update, Debate do |debate|
      #   debate.editable_by?(user)
      # end

      can :read, Proposal
      can :update, Proposal do |proposal|
        proposal.editable_by?(user)
      end
      can [:retire_form, :retire], Proposal, author_id: user.id

      can :read, SpendingProposal
      can :read, Legislation::Proposal
      cannot [:edit, :update], Legislation::Proposal do |proposal|
        proposal.editable_by?(user)
      end
      can [:retire_form, :retire], Legislation::Proposal, author_id: user.id

      can :create, Comment
      # can :create, Debate
      can :create, Proposal
      can :create, AnsweredSurvey
      can :create, Budget::Investment,               budget: { phase: "accepting" }
      can :read, AnsweredSurvey, user_id: user.id
      can :read, Survey

      can :suggest, Debate
      can :suggest, Proposal
      can :suggest, Legislation::Proposal
      can :suggest, ActsAsTaggableOn::Tag

      can [:flag, :unflag], Comment
      cannot [:flag, :unflag], Comment, user_id: user.id

      can [:flag, :unflag], Debate
      cannot [:flag, :unflag], Debate, author_id: user.id

      can [:flag, :unflag], Proposal
      cannot [:flag, :unflag], Proposal, author_id: user.id

      can [:flag, :unflag], Legislation::Proposal
      cannot [:flag, :unflag], Legislation::Proposal, author_id: user.id

      can [:create, :destroy], Follow

      can [:destroy], Document, documentable: { author_id: user.id }

      can [:destroy], Image, imageable: { author_id: user.id }

      can [:create, :destroy], DirectUpload

      unless user.organization?
        can :vote, Debate
        can :vote, Comment
      end

      if user.level_two_or_three_verified?
        can :vote, Proposal
        can :vote_featured, Proposal
        can :vote, SpendingProposal
        can :create, SpendingProposal

        can :vote, Legislation::Proposal
        can :vote_featured, Legislation::Proposal
        can :create, Legislation::Answer

        # can :create, Budget::Investment,               budget: { phase: "accepting" }
        can :suggest, Budget::Investment,              budget: { phase: "accepting" }
        can :destroy, Budget::Investment,              budget: { phase: ["accepting", "reviewing"] }, author_id: user.id
        can :vote, Budget::Investment,                 budget: { phase: "selecting" }

        can [:show, :create], Budget::Ballot,          budget: { phase: "balloting" }
        can [:create, :destroy], Budget::Ballot::Line, budget: { phase: "balloting" }

        can :create, DirectMessage
        can :show, DirectMessage, sender_id: user.id
        can :answer, Poll do |poll|
          poll.answerable_by?(user)
        end
        can :answer, Poll::Question do |question|
          question.answerable_by?(user)
        end

        Verification::Residence::GEOZONE_PROTECTIONS.each do |protection|
          if user.geozone_id != protection[:geozone_id] && protection[:action].present? && protection[:model_name].present? && protection[:model_id].present?
              cannot protection[:action], protection[:model_name].constantize, id: protection[:model_id]
          end
        end
      end

      can [:create, :show], ProposalNotification, proposal: { author_id: user.id }

      can :create, Annotation
      can [:update, :destroy], Annotation, user_id: user.id

      can [:create], Topic
      can [:update, :destroy], Topic, author_id: user.id
    end
  end
end
