module CustomHelper
  def thematics_areas
    I18n.t('debates.edit.area').values
  end

  def proposal_area_options
    Proposal::AREAS.map {|option| [ t("proposals.edit.area.#{option}"), option ] }
  end
end
