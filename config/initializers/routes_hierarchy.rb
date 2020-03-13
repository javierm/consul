# This module is expanded in order to make it easier to use polymorphic
# routes with nested resources.
# HACK: is there a way to avoid monkey-patching here? Using helpers is
# a similar use of a global namespace too...
module ActionDispatch::Routing::UrlFor
  def resource_hierarchy_for(resource)
    case resource.class.name
    when "Budget::Investment", "Budget::Phase", "Budget::Group"
      [resource.budget, resource]
    when "Budget::Heading"
      [resource.group.budget, resource.group, resource]
    when "Milestone"
      [*resource_hierarchy_for(resource.milestoneable), resource]
    when "ProgressBar"
      [*resource_hierarchy_for(resource.progressable), resource]
    when "Audit"
      [*resource_hierarchy_for(resource.associated || resource.auditable), resource]
    when "Legislation::Annotation"
      [resource.draft_version.process, resource.draft_version, resource]
    when "Legislation::Proposal", "Legislation::Question", "Legislation::DraftVersion"
      [resource.process, resource]
    when "Topic"
      [resource.community, resource]
    else
      resource
    end
  end

  def polymorphic_hierarchy_path(resource, options = {})
    polymorphic_path(resource_hierarchy_for(resource), options)
  end
end
