class Browser
  @@headless = true
  @@driver = nil
  @@tab_hs = []

  def self._driver()
    return @@driver
  end
  def self.__driver(value)
    @@driver = value
  end


  def self.open()
    Selenium::WebDriver::Chrome::Service.driver_path = "drivers/chromedriver.exe"
    options = Selenium::WebDriver::Chrome::Options.new
    if @@headless
      options.add_argument("--headless")
    end
    @@driver = Selenium::WebDriver.for(:chrome, options: options)
  end

  def self.new_tab()
    @@tab_hs << @@driver.window_handle
    #@@driver.manage.new_window(:tab)
    @@driver.execute_script("window.open()")
    @@driver.window_handles.each do |handle|
      if not @@tab_hs.include? handle
        @@driver.switch_to.window handle
        break
      end
    end
  end
  def self.close_tab()
    @@driver.close
    @@driver.switch_to.window @@tab_hs.pop
  end

  def self.clean()
    @@driver.manage.delete_all_cookies
    main_window_h = @@driver.window_handle
    for window_h in @@driver.window_handles
      if window_h != main_window_h
        @@driver.switch_to.window window_h
        @@driver.close
      end
    end
    @@driver.switch_to.window main_window_h
  end
end


BeforeAll do
  Browser.open
end

AfterAll do
  Browser._driver.quit
end

Before do
  Browser.clean
end
