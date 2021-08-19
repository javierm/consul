class Admin::ActionComponent < ApplicationComponent
  include Admin::Namespace
  attr_reader :action, :record, :options

  def initialize(action, record, **options)
    @action = action
    @record = record
    @options = options
  end

  private

    def text
      options[:text] || t("admin.actions.#{action}")
    end

    def path
      options[:path] || default_path
    end

    def html_options
      {
        class: html_class,
        "aria-label": label,
        data: { confirm: confirmation_text }
      }.merge(options.reject { |key, _| %i[confirm text path].include?(key) })
    end

    def html_class
      "#{action.to_s.gsub("_", "-")}-link"
    end

    def label
      t("admin.actions.label", action: text, name: record_name)
    end

    def confirmation_text
      if options[:confirm] == true
        if action == :destroy
          t("admin.actions.confirm_delete",
            resource_name: resource_name,
            name: record_name)
        else
          t("admin.actions.confirm_action",
            action: text,
            resource_name: resource_name,
            name: record_name)
        end
      else
        options[:confirm]
      end
    end

    def record_name
      if record.respond_to?(:human_name)
        record.human_name
      else
        record.to_s.humanize
      end
    end

    def resource_name
      t("admin.models.#{record.model_name.i18n_key}",
        default: record.model_name.human,
        fallback: nil)
    end

    def default_path
      if %i[answers configure destroy preview show].include?(action.to_sym)
        namespaced_polymorphic_path(namespace, record)
      else
        namespaced_polymorphic_path(namespace, record, { action: action }.merge(request.query_parameters))
      end
    end
end
