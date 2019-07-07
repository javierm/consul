class ProposalChannel < ApplicationCable::Channel
  def subscribed
    stream_from "proposal_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def vote
  end
end
