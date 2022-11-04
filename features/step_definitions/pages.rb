class Pages
  @@server_address = "http://127.0.0.1:8000"


  def self.get_api_page_address(cmd_name)
    return @@server_address + "/testing_api/?cmd=" + cmd_name
  end
  def self.get_index_page_address()
    return @@server_address + "/"
  end
  def self.get_login_page_address()
    return @@server_address + "/login/"
  end
  def self.get_registration_page_address()
    return @@server_address + "/registration/"
  end
  def self.get_my_profile_page_address()
    return @@server_address + "/my_profile/"
  end
end


Given(/^"([^"]*)" page is opened$/) do |url|
  Browser._driver.get url
end
Given(/^index page is opened$/) do
  Browser._driver.get Pages.get_index_page_address
end
Given(/^login page is opened$/) do
  Browser._driver.get Pages.get_login_page_address
end
Given(/^registration page is opened$/) do
  Browser._driver.get Pages.get_registration_page_address
end
Given(/^my_profile page is opened$/) do
  Browser._driver.get Pages.get_my_profile_page_address
end

When(/^I navigate to login page$/) do
  Browser._driver.find_element(xpath: "//a[text()='Войти']").click
end
When(/^I navigate to registration page$/) do
  Browser._driver.find_element(xpath: "//a[text()='Регистрация']").click
end
When(/^I navigate to my_profile page$/) do
  Browser._driver.find_element(xpath: "//a[text()='Мой профиль']").click
end

Then(/^I verify index page is loaded$/) do
  raise "AE" unless Browser._driver.current_url == Pages.get_index_page_address
end
Then(/^I verify login page is loaded$/) do
  raise "AE" unless Browser._driver.current_url == Pages.get_login_page_address
end
Then(/^I verify registration page is loaded$/) do
  raise "AE" unless Browser._driver.current_url == Pages.get_registration_page_address
end
