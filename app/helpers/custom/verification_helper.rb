module Custom::VerificationHelper
  def genders
    [[t("verification.residence.new.gender.male"), "male"],
    [t("verification.residence.new.gender.female"), "female"],
    [t("verification.residence.new.gender.other"), "other"]]
  end

  def document_type_dni
    [[t("verification.residence.new.document_type.spanish_id"), 1],
     # [t("verification.residence.new.document_type.passport"), 2],
     # [t("verification.residence.new.document_type.residence_card"), 3],
     [t("verification.residence.new.document_type.foreign_id"), 4]]
  end
end
