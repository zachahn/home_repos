require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  def test_logged_out_lists_only_public_projects
    FactoryBot.create(:project, name: "foo_project")
    FactoryBot.create(:project, name: "bar_project")
    FactoryBot.create(:project, :private, name: "baz_project")

    get(projects_url)

    assert_response(:success)
    assert_match(/foo_project/, @response.body)
    assert_match(/bar_project/, @response.body)
    refute_match(/baz_project/, @response.body)
  end

  def test_authorized_users_lists_all_projects
    FactoryBot.create(:project, name: "foo_project")
    FactoryBot.create(:project, name: "bar_project")
    FactoryBot.create(:project, :private, name: "baz_project")
    admin = FactoryBot.create(:user, :admin)

    login_as(admin)
    get(projects_url)

    assert_response(:success)
    assert_match(/foo_project/, @response.body)
    assert_match(/bar_project/, @response.body)
    assert_match(/baz_project/, @response.body)
  end

  def test_dont_show_if_not_export
    FactoryBot.create(:project, :private, name: "one_commit")
    admin = FactoryBot.create(:user, :admin)

    begin
      get(project_url(name: "one_commit"))
    rescue ActionController::RoutingError
    end

    login_as(admin)
    get(project_url(name: "one_commit"))
  end

  def test_show_repo_root
    FactoryBot.create(:project, name: "one_commit")

    get(project_url(name: "one_commit"))

    assert_match(/first\.txt/, @response.body)
  end
end
