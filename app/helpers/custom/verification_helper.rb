module Custom::VerificationHelper
  def genders
    [[t("verification.residence.new.gender.male"), "male"],
    [t("verification.residence.new.gender.female"), "female"],
    [t("verification.residence.new.gender.other"), "other"]]
  end
end
