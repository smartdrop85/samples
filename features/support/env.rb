require 'capybara'
require 'capybara/cucumber'
require 'selenium-webdriver'
require 'mail'
require 'cucumber'
require 'rspec'
require 'pathname'
require 'capybara-screenshot/cucumber'

Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.default_selector = :css
Capybara.default_max_wait_time = 7

rendered_config = ERB.new(File.read('config/config.json')).result binding
$config = JSON.parse(rendered_config)

#create results folder if it is not present
directory_name = "results"
Dir.mkdir(directory_name) unless File.exists?(directory_name)

$downloads_path = if ENV['TEST_ENV_NUMBER'].nil?
                    File.join(Dir.pwd, 'temp_downloads', '1')
                  else
                    File.join(Dir.pwd, 'temp_downloads', ENV['TEST_ENV_NUMBER'])
                  end
path = if Selenium::WebDriver::Platform.windows?
         $downloads_path.tr('/', '\\')
       else
         $downloads_path
       end

Capybara.register_driver :selenium do |app|
  if $config['browser'] == 'chrome'
    prefs = {
        download: {
            prompt_for_download: false,
            default_directory: path
        }
    }
    Capybara::Selenium::Driver.new(app, detach: false, browser: :chrome, prefs: prefs)
  else
    profile = Selenium::WebDriver::Firefox::Profile.new
    profile['browser.download.folderList'] = 2
    profile['browser.download.dir'] = path
    profile['browser.helperApps.neverAsk.saveToDisk'] = 'application/octet-stream,application/xml,text/plain,text/xml,image/png,text/csv,application/pdf,application/zip,application/binary,application/x-yaml'
    profile.native_events = 'true'
    client = Selenium::WebDriver::Remote::Http::Default.new
    client.open_timeout = 600 # instead of the default 60
    client.read_timeout = 200
    Capybara::Selenium::Driver.new(app, browser: :firefox, profile: profile, http_client: client, desired_capabilities: Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false))
  end

  # Remote server checks
  # caps = Selenium::WebDriver::Remote::Capabilities.new
  # caps["browser"] = "Firefox"
  # caps["browser_version"] = "40"
  # caps["os"] = "Windows"
  # caps["os_version"] = "XP"
  # caps["browserstack.debug"] = "true"
  # caps["name"] = "Testing Selenium 2 with Ruby on BrowserStack"
  # caps['browserstack.local'] = 'true'
  #
  # Capybara::Selenium::Driver.new(app, :browser => :remote, :url => "http://mayyabatyukova1:u4tRxMZKkwGExRGqtAtA@hub.browserstack.com/wd/hub", :desired_capabilities => caps)
end