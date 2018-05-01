require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  def test_admins_can_create_project
    FactoryBot.create(:user, :admin, email: "hi@example.com", password: "hello")

    visit root_path
    click_on "Log in"

    fill_in "Email", with: "hi@example.com"
    fill_in "Password", with: "hello"
    click_on "Login"

    assert_text "Logged in as hi@example.com"

    click_on "New project"

    fill_in "Name", with: "new_project"
    fill_in "Description", with: "My new project"
    choose "Private"
    click_on "Create Project"

    assert_current_path(project_path("new_project"))
  end
end
