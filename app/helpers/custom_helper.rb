module CustomHelper
  def proposal_area_options
    Proposal::AREAS.map {|option| [ t("proposals.edit.area.#{option}"), option ] }
  end
end
