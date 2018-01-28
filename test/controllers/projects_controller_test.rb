require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  def test_logged_out_lists_only_public_projects
    FactoryBot.create(:project, path: "tmp/foo_project.git", export: true)
    FactoryBot.create(:project, path: "tmp/bar_project.git", export: true)
    FactoryBot.create(:project, path: "tmp/baz_project.git", export: false)

    get(projects_url)

    assert_response(:success)
    assert_match(/foo_project/, @response.body)
    assert_match(/bar_project/, @response.body)
    refute_match(/baz_project/, @response.body)
  end

  def test_authorized_users_lists_all_projects
    FactoryBot.create(:project, path: "tmp/foo_project.git", export: true)
    FactoryBot.create(:project, path: "tmp/bar_project.git", export: true)
    FactoryBot.create(:project, path: "tmp/baz_project.git", export: false)
    admin = FactoryBot.create(:user, :admin)

    post(session_url, params: { email: admin.email, password: admin.password })
    get(projects_url)

    assert_response(:success)
    assert_match(/foo_project/, @response.body)
    assert_match(/bar_project/, @response.body)
    assert_match(/baz_project/, @response.body)
  end
end
