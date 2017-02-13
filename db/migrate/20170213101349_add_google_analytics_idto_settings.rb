class AddGoogleAnalyticsIdtoSettings < ActiveRecord::Migration
  def change
    setting = Setting.new(key: "google_tracking", value: "UA-91532166-1")
    setting.save!
  end

  def down
    setting = Setting.where(key:"google_tracking").first
    setting.destroy
  end
end
