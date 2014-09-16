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

  def test_identity
    @@keys['1'].click

    text = textfield(1).text

    assert_equal text, '1'
  end

  def test_identity_more
    regular_keys =*('0'..'9')
    regular_keys = regular_keys.concat ['+','-','*','/','.']

    # this is important! Testing is a balance of statelessness and speed
    prior_value = textfield(1).text

    regular_keys.each do |key_name|
      @@keys[key_name].click
    end

    assert_equal prior_value << regular_keys.join(''), textfield(1).text
  end

  def test_clear
    # this test actually runs first!
    @@keys['1'].click
    @@keys['CE'].click

    assert_equal "0.0", @@display.text
  end

end
