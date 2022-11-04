class ApiCommand
  def initialize(name, args)
    @name = name
    @args = args
  end

  def execute()
    url = Pages.get_api_page_address(@name)
    Browser._driver.get(url)
    get_status = Browser._driver.find_element(xpath: "html/body").text
    if get_status == "400"
      raise "Command load has failed!"
    end
    for key, value in @args
      arg_xpath = "html/body/form/input[@name='" + key + "']"
      Browser._driver.find_element(xpath: arg_xpath).send_keys value
    end
    Browser._driver.find_element(xpath: "html/body/form/button").click
    post_status = Integer(Browser._driver.find_element(xpath: "html/body").text)
    if post_status == 400
      raise "Command execution has failed!"
    end
    return post_status
  end

  def self.del_user(login, password)
    return ApiCommand.new("del_user", {
        "login" => login,
        "password" => password,
    })
  end
  def self.has_user(login)
    return ApiCommand.new("has_user", {
        "login" => login,
    })
  end
end
