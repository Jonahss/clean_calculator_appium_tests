require 'rubygems'
require 'appium_lib'
require 'minitest/autorun'
require 'minitest/spec'
require 'test/unit'

class TestCleanCalc < Test::Unit::TestCase

  desired_capabilities = {
    'platformName' =>       "Android",
    'platformVersion' =>    "4.4",
    'deviceName' =>         "Android S4",
    'appPackage' =>         "home.jmstudios.calc",
    'appActivity' =>        "Main",
    'newCommandTimeout' =>  100000
  }

  @driver = Appium::Driver.new(caps: desired_capabilities)
  Appium.promote_appium_methods Object
  @driver.start_driver

  @@keys = Hash[buttons.map{|button| [button.text, button]}]

  def displayed
    textfield(1).text
  end

  def hit_keys str
    key_names = str.split ""
    key_names.each do |key_name|
      @@keys[key_name].click
    end
  end

  def clear
    @@keys['CE'].click
  end

  def assert_calculation problem, solution
    clear
    hit_keys problem << '='
    assert_equal solution.to_s, displayed
  end

  def test_backgrounding_app

    hit_keys "12+45"

    driver.background_app 3
    hit_keys "="

    assert_equal "57", displayed

  end

end
