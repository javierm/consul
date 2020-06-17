class Admin::Officials::FormComponent < ApplicationComponent
  attr_reader :user

  def initialize(user)
    @user = user
  end

  private

    def official_level_options
      options = [["", 0]]
      (1..5).each do |i|
        options << [[t("admin.officials.level_#{i}"), setting["official_level_#{i}_name"]].compact.join(": "), i]
      end
      options
    end
end
