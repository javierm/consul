module CustomHelper
  def thematics_areas
    I18n.t('debates.edit.area').values
  end

  def proposal_area_options
    Proposal::AREAS.map {|option| [ t("proposals.edit.area.#{option}"), option ] }
  end

  ALLOWED_TAGS = %w(p ul ol li strong em u s iframe img)
  ALLOWED_ATTRIBUTES =  %w(class style href width height src alt)

  def text_in_html(text)
    return unless text
    sanitized = sanitize(text, tags: ALLOWED_TAGS, attributes: ALLOWED_ATTRIBUTES)
    Rinku.auto_link(sanitized, :all, 'target="_blank" rel="nofollow"').html_safe
  end

end
