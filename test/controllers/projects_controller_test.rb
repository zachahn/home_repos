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

    post(session_url, params: { email: admin.email, password: admin.password })
    get(projects_url)

    assert_response(:success)
    assert_match(/foo_project/, @response.body)
    assert_match(/bar_project/, @response.body)
    assert_match(/baz_project/, @response.body)
  end

  def test_dont_show_if_not_export
    FactoryBot.create(:project, :private, name: "foo_bar")
    admin = FactoryBot.create(:user, :admin)

    begin
      get(project_url(name: "foo_bar"))
    rescue ActionController::RoutingError
    end

    post(session_url, params: { email: admin.email, password: admin.password })
    get(project_url(name: "foo_bar"))
  end
end
