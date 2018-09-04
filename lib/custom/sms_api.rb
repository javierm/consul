require_dependency Rails.root.join('lib', 'sms_api').to_s

class SMSApi
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
      text: "Tu residencia ha sido verificada. Para completar el proceso, introduce el siguiente código: #{code}. Participa Gran Canaria"}
  end

  def success?(response)
    response.body[:create_message_response][:create_message_result][:error_code] == "0"
  end

  def stubbed_response
    {:create_message_response=>{:create_message_result=>{:error_code=>"0", :error_description=>nil, :result=>{:id=>"1234567", :total_messages=>"1"}}, :@xmlns=>"http://aplicateca.didimo.es/"}}
  end
end
