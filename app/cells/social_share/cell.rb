class SocialShare::Cell < ApplicationCell
  include SocialShareButton::Helper

  locals :share_title, :title, :description, :version_name, :process_name, :url, :mobile, :image_url

  def show
    render
  end
end
