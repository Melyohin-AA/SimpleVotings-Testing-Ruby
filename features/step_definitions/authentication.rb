class Authentication
  @@login = nil
  @@password = nil
  @@authenticated = false

  def self._login()
    return @@login
  end
  def self._password()
    return @@password
  end
  def self._authenticated()
    return @@authenticated
  end
  def self.__authenticated(value)
    @@authenticated = value
  end

  def self.log_in(login, password)
    Browser._driver.get Pages.get_login_page_address
    submit_credentials(login, password)
  end
  def self.submit_credentials(login, password)
    @@login = login
    @@password = password
    Browser._driver.find_element(id: "id_username").send_keys login
    Browser._driver.find_element(id: "id_password").send_keys password
    Browser._driver.find_element(xpath: "//button[@type='submit']").click
    @@authenticated = Browser._driver.current_url == Pages.get_index_page_address
  end

  def self.log_out()
    Browser._driver.get Pages.get_index_page_address
    click_logout_link
  end
  def self.click_logout_link()
    Browser._driver.find_element(xpath: "//a[text()='Выйти']").click
    @@authenticated = false
  end
end


Before do
  Authentication.__authenticated(false)
end

Given(/^logged in as "([^"]*)":"([^"]*)"$/) do |login, password|
  Authentication.log_in(login, password)
end

When(/^I try to log in as "([^"]*)":"([^"]*)"$/) do |login, password|
  Authentication.submit_credentials(login, password)
end
When(/^I try to log out$/) do
  Authentication.click_logout_link
end

Then(/^I verify login is proper$/) do
  actual = Browser._driver.find_element(xpath: "//label[text()='Логин']/../input").attribute("value")
  raise "AE" unless actual == Authentication._login
end
Then(/^I verify credentials are rejected$/) do
  raise "AE" unless Browser._driver.current_url == Pages.get_login_page_address
end
Then(/^I verify I am authenticated$/) do
  raise "AE" unless Browser._driver.find_element(xpath: "//a[text()='Выйти']").displayed?
end
Then(/^I verify I am not authenticated$/) do
  raise "AE" unless Browser._driver.find_element(xpath: "//a[text()='Войти']").displayed?
end
