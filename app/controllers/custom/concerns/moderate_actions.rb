require_dependency Rails.root.join('app', 'controllers', 'concerns', 'moderate_actions').to_s

module ModerateActions

  def moderate
    set_resource_params
    @resources = @resources.where(id: params[:resource_ids] || params[:areas].try(:keys))

    if params[:hide_resources].present?
      @resources.accessible_by(current_ability, :hide).each {|resource| hide_resource resource}

    elsif params[:ignore_flags].present?
      @resources.accessible_by(current_ability, :ignore_flag).each(&:ignore_flag)

    elsif params[:block_authors].present?
      author_ids = @resources.pluck(author_id).uniq
      User.where(id: author_ids).accessible_by(current_ability, :block).each {|user| block_user user}

    elsif params[:update_areas].present?
      @resources.accessible_by(current_ability, :update_area).each do |resource|
        val = params[:areas][resource.id.to_s]
        next unless val.present?
        resource.area_revised(val)
      end

    end

    redirect_to request.query_parameters.merge(action: :index)
  end

end
