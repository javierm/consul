class UpdateArchiveProposalsSetting < ActiveRecord::Migration
  def up
    setting = Setting.where(key:"months_to_archive_proposals").first_or_initialize
    setting.key = "days_to_archive_proposals"
    setting.value = 45
    setting.save!
  end

  def down
    setting = Setting.where(key:"days_to_archive_proposals").first_or_initialize
    setting.key = "months_to_archive_proposals"
    setting.value = 12
    setting.save!
  end
end
