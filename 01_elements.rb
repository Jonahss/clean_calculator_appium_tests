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
  #  'app' => "/Users/jonahss/Workspace/clean-calculator/out/production/clean-calculator/clean-calculator.apk",
    'newCommandTimeout' =>  100000
  }

  @driver = Appium::Driver.new(caps: desired_capabilities)
  Appium.promote_appium_methods Object
  @driver.start_driver

  def test_has_text_field
    assert_operator textfields.size, :>=, 1
  end

  def test_has_buttons
    assert_operator buttons.size, :>, 3
  end

  def test_has_button_7
    assert_not_nil button '1'
    assert_not_nil button '='
  end

  def test_has_the_buttons_we_want
    # create list of buttons we expect the UI to contain
    buttons_expected =*('0'..'9')
    buttons_expected.concat ['CE','+','-','*','/','=','.']

    print 'buttons expected: '
    print buttons_expected

    # for each button, remove it from the list of expected buttons
    buttons.each do |button|
      buttons_expected.delete button.text
    end

    # if the list of expected buttons is empty, we've seen all the buttons we expected
    assert buttons_expected.empty?
  end

end
