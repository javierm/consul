module CustomHelper
  def thematics_areas
    [t('debate.area1'),
     t('debate.area2'),
     t('debate.area3')]
  end
  def proposal_area_options
    Proposal::AREAS.map {|option| [ t("proposals.edit.area.#{option}"), option ] }
  end
end
