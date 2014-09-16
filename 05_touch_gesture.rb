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

  @@display = textfield(1)

  def hit_keys str
    key_names = str.split ""
    key_names.each do |key_name|
      @@keys[key_name].click
    end
  end

  def clear
    button('CE').click
  end

  def displayed
    @@display.text
  end

  def assert_calculation problem, solution
    clear
    hit_keys problem << '='
    assert_equal solution.to_s, displayed
  end

  def test_a_loooong_press
    seven = button '7'

    clear
    action = Appium::TouchAction.new()
    action.press(:element => seven, x: 0.5, y: 0.5)
          .wait(3000)
          .release()
          .perform

    assert_equal '7', displayed
  end

  def test_the_sliiiiiiiide

    seven = button '7'
    one = button '1'

    clear
    action = Appium::TouchAction.new()
    action.press(:element => seven, x: 0.5, y: 0.5)
          .wait(2000)
          .wait(2000)
          .move_to(:element => one)
          .release()
          .perform

    assert_equal '0.0', displayed
  end

end
