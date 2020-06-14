class Admin::TableActionsComponent < ApplicationComponent
  attr_reader :record, :options

  def initialize(record = nil, **options)
    @record = record
    @options = options
  end

  def link_to_add_user(text, path)
    icon_link_to text, path, icon: "fas fa-user-plus", method: :post
  end

  private

    def actions
      options[:actions] || [:edit, :destroy]
    end

    def edit_text
      options[:edit_text] || t("admin.actions.edit")
    end

    def edit_path
      options[:edit_path] || admin_polymorphic_path(record, action: :edit)
    end

    def destroy_text
      options[:destroy_text] || t("admin.actions.delete")
    end

    def destroy_path
      options[:destroy_path] || admin_polymorphic_path(record)
    end

    def destroy_confirmation
      options[:destroy_confirmation] || t("admin.actions.confirm")
    end
end
