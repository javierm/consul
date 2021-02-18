require_dependency Rails.root.join("lib", "census_caller").to_s

class CensusCaller
  def call(document_type, document_number, other_data = {})
    if Setting["feature.remote_census"].present?
      response = RemoteCensusApi.new.call(document_type, document_number, other_data[:date_of_birth], other_data[:postal_code])
    else
      response = CensusApi.new.call(document_type, document_number, other_data)
      return response if response.error =~ /^Servicio no disponible/
    end
    response = LocalCensus.new.call(document_type, document_number) unless response.valid?

    response
  end
end
