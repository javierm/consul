require_dependency Rails.root.join("app", "models", "proposal").to_s

class Proposal
  def self.for_summary
    summary = {}
    categories = Tag.category_names.sort
    geozones   = Geozone.names.sort

    groups = categories + geozones
    groups.each do |group|
      summary[group] = search(group).sort_by_confidence_score.limit(3)
    end
    summary
  end
end

