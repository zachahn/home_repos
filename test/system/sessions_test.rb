require "application_system_test_case"

class SessionsTest < ApplicationSystemTestCase
  def test_logging_in
    FactoryBot.create(:user, email: "hi@example.com", password: "hello")

    visit root_path
    click_on "Log in"

    visit new_session_path
    fill_in "Email", with: "hi@example.com"
    fill_in "Password", with: "helo"

    click_on "Login"

    assert_text "Incorrect"

    fill_in "Password", with: "hello"

    click_on "Login"

    assert_text "Logged in as hi@example.com"
  end
end
