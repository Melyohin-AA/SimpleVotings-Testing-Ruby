class Registration
  @@login = nil
  @@password = nil
  @@to_delete = false

  def self._login()
    return @@login
  end
  def self._password()
    return @@password
  end
  def self._to_delete()
    return @@to_delete
  end
  def self.__to_delete(value)
    @@to_delete = value
  end


  def self.generate_unique_login(min_length, max_length, ch_min, ch_max)
    Browser.new_tab
    rnd = Random.new
    while true
      length = rnd.rand(min_length..max_length)
      sb = StringIO.new
      for i in 1..length
        sb << rnd.rand(ch_min..ch_max).chr
      end
      login = sb.string
      status = ApiCommand.has_user(login).execute
      if status != 200
        break
      end
    end
    Browser.close_tab
    return login
  end

  def self.submit_user_registration(login, pw1, pw2, name)
    @@login = login
    @@password = pw1
    Browser._driver.find_element(id: "id_login").send_keys login
    Browser._driver.find_element(id: "id_password1").send_keys pw1
    Browser._driver.find_element(id: "id_password2").send_keys pw2
    Browser._driver.find_element(id: "id_name").send_keys name
    Browser._driver.find_element(id: "reg_button").click
  end

  def self.try_delete()
    if @@to_delete
      @@to_delete = false
      status = ApiCommand.del_user(@@login, @@password).execute
      puts "Account deletion: " + String(status)
    end
  end
end


After do
  Registration.try_delete
end

When(/^I try register as login="([^"]*)", PW1="([^"]*)", PW2="([^"]*)", name="([^"]*)"$/) do |login, pw1, pw2, name|
  Registration.submit_user_registration(login, pw1, pw2, name)
end
When(/^I try register as unique PW1="([^"]*)", PW2="([^"]*)", name="([^"]*)"$/) do |pw1, pw2, name|
  login = Registration.generate_unique_login(1, 64, 32, 126)
  Registration.submit_user_registration(login, pw1, pw2, name)
end

Then(/^I verify registration is succeeded$/) do
  raise "AE" unless Browser._driver.find_element(xpath: "//div[contains(@class,'alert-success')]").displayed?
  Registration.__to_delete(true)
end
Then(/^I verify registration is rejected$/) do
  Registration.__to_delete(true)
  begin
    raise "AE" if Browser._driver.find_element(xpath: "//div[contains(@class,'alert-success')]").displayed?
  rescue Selenium::WebDriver::Error::NoSuchElementError
  end
  Registration.__to_delete(false)
end
