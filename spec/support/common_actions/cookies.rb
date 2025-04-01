module Cookies
  def all_cookies
    page.driver.browser.manage.all_cookies # TODO: private method browser
  end

  def cookie_by_name(name)
    all_cookies.find { |cookie| cookie[:name] == name }
  end
end
