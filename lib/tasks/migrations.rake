namespace :migrations do
  desc "Add name to existing budget phases"
  task add_name_to_existing_budget_phases: :environment do
    Budget::Phase::Translation.find_each do |translation|
      unless translation.name.present?
        i18n_name = I18n.t("budgets.phase.#{translation.globalized_model.kind}", locale: translation.locale)
        translation.update!(name: i18n_name)
      end
    end
  end

  desc "Copies the Budget::Phase summary into description"
  task budget_phases_summary_to_description: :environment do
    Budget::Phase::Translation.find_each do |phase|
      if phase.summary.present?
        phase.description << "<br>"
        phase.description << phase.summary
        phase.save!
      end
    end
  end
end
