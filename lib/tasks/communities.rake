namespace :communities do

  desc "Associate community to proposals and budget investments"
  task associate_community: :environment do

    Proposal.all.each do |proposal|
      if proposal.community.blank?
        proposal.update(community: Community.create)
      end
    end

    Budget::Investment.all.each do |investment|
      if investment.community.blank?
        investment.update(community: Community.create)
      end
    end
  end
end
