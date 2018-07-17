class Community < ActiveRecord::Base
  has_one :proposal
  has_one :investment, class_name: Budget::Investment
  has_many :topics

  def participants
    users_participants = users_who_commented +
                         users_who_topics_author +
                         author_from_community
    users_participants.uniq
  end

  def from_proposal?
    proposal.present?
  end

  def communitable
    from_proposal? ? proposal : investment
  end

  def communitable_type
    communitable.class.name
  end

  def communitable_key
    communitable_type.split("::").last.underscore
  end

  private

  def users_who_commented
    topics_ids = topics.pluck(:id)
    query = "comments.commentable_id IN (?)and comments.commentable_type = 'Topic'"
    User.by_comments(query, topics_ids)
  end

  def users_who_topics_author
    author_ids = topics.pluck(:author_id)
    User.by_authors(author_ids)
  end

  def author_from_community
    User.where(id: communitable&.author_id)
  end

end
