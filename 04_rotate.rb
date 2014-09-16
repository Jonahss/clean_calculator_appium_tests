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

  @@keys = {}
  # a hash of keys predefined is no longer enough, rotating changes the views
  def load_keys
    @@keys = Hash[buttons.map{|button| [button.text, button]}]
  end

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

  def setup
    driver.rotate :portrait
  end

  def teardown
    driver.rotate :portrait
  end

  def test_rotate
    driver.rotate :landscape
    load_keys
    assert_calculation "12+34", 12+34
  end

  def test_rotate_extreme
    # I found a bug!

    driver.rotate :landscape
    load_keys
    hit_keys "12"

    driver.rotate :portrait
    load_keys
    hit_keys "+45"

    driver.rotate :landscape
    load_keys
    hit_keys "="

    assert_equal "57", displayed

    # notice how assert_calculation wasn't used.
  end

end
