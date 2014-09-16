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

  # a hash of our calculator keys
  @@keys = Hash[buttons.map{|button| [button.text, button]}]

  @@display = textfield(1)


  def hit_keys str
    key_names = str.split ""
    key_names.each do |key_name|
      @@keys[key_name].click
    end
  end

  def clear
    @@keys['CE'].click
  end

  def displayed
    @@display.text
  end

  def test_simple_operations
    clear
    hit_keys "1+2="
    assert_equal "3", displayed
  end

  def assert_calculation problem, solution
    clear
    hit_keys problem << '='
    assert_equal solution.to_s, displayed
  end

  def test_more_operations

    # one of these will fail because our calculator isn't flawless. Can you guess which one?
    assert_calculation "1+2+3", 1+2+3
    assert_calculation "5000*25064", 5000*25064
    assert_calculation "4-6.777777+78.0*7650", 4.0-6.777777+78.0*7650.0
    assert_calculation "1.234/0.009", 1.234/0.009
  end

  # we could stand to test a lot more...

end
