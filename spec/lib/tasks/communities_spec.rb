require 'rails_helper'
require 'rake'

describe 'Communities Rake' do
  before do
    Rake.application.rake_require "tasks/communities"
    Rake::Task.define_task(:environment)
  end

  describe '#associate_community' do

    let :run_rake_task do
      Rake::Task['communities:associate_community'].reenable
      Rake.application.invoke_task 'communities:associate_community'
    end

    context 'Associate community to Proposal' do

      it 'When proposal has not community_id' do
        proposal = create(:proposal)
        proposal.update(community: nil)
        expect(proposal.community).to be_nil

        run_rake_task
        proposal.reload

        expect(proposal.community).to be_present
      end
    end

    context 'Associate community to Budget Investment' do

      it 'When budget investment has not community_id' do
        investment = create(:budget_investment)
        investment.update(community: nil)
        expect(investment.community).to be_nil

        run_rake_task
        investment.reload

        expect(investment.community).to be_present
      end

    end

  end
end
