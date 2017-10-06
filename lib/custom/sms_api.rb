require 'open-uri'
class SMSApi
  attr_accessor :client

  def initialize
    @client = Savon.client(wsdl: url)
  end

  def url
    return "" unless end_point_available?
    Rails.application.secrets.sms_end_point
  end

  def authorization
    Base64.encode64("#{Rails.application.secrets.sms_username}:#{Rails.application.secrets.sms_password}")
  end

  def sms_deliver(phone, code)
    return stubbed_response unless end_point_available?

    response = client.call(:create_message, message: request(phone, code))
    success?(response)
  end

  def request(phone, code)
    { login: Rails.application.secrets.sms_username,
      password: Rails.application.secrets.sms_password,
      mobile: phone,
      name: "Participa Gran Canaria",
      text: "Clave para verificarte: #{code}. Participa Gran Canaria"}
  end

  def success?(response)
    response.body[:create_message_response][:create_message_result][:error_code] == "0"
  end

  def end_point_available?
    Rails.env.staging? || Rails.env.preproduction? || Rails.env.production?
  end

  def stubbed_response
    {:create_message_response=>{:create_message_result=>{:error_code=>"0", :error_description=>nil, :result=>{:id=>"1234567", :total_messages=>"1"}}, :@xmlns=>"http://aplicateca.didimo.es/"}}
  end

end
