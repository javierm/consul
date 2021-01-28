module Custom::VerificationHelper
  def genders
    [[t("verification.residence.new.gender.male"), "male"],
    [t("verification.residence.new.gender.female"), "female"],
    [t("verification.residence.new.gender.other"), "other"]]
  end

  def document_type_dni
    [[t("verification.residence.new.document_type.spanish_id"), 1]]
  end
end
