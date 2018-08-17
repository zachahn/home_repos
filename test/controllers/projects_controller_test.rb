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

  def test_logged_in_users_see_their_own_projects
    FactoryBot.create(:project, name: "foo_project")
    FactoryBot.create(:project, :private, name: "bar_project")
    personal_project = FactoryBot.create(:project, :private, name: "baz_project")
    user = FactoryBot.create(:user)
    Permission.create!(project: personal_project, user: user)

    login_as(user)
    get(projects_url)

    assert_response(:success)
    refute_match(/foo_project/, @response.body)
    refute_match(/bar_project/, @response.body)
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

  def test_show_private_project_to_user_with_access
    project = FactoryBot.create(:project, :private, name: "one_commit")
    user = FactoryBot.create(:user)
    Permission.create!(user: user, project: project)

    login_as(user)
    get(project_url(name: "one_commit"))
    assert_match(/first\.txt/, @response.body)
  end

  def test_only_admin_can_create_project
    assert_difference(-> { Project.all.size }, 0) do
      post(projects_url,
        params: { project: { name: "hi", description: "lol", export: "true" } }
      )
    end

    assert_difference(-> { Project.all.size }, 0) do
      login_as(FactoryBot.create(:user))
      post(projects_url,
        params: { project: { name: "hi", description: "lol", export: "true" } }
      )
    end

    assert_difference(-> { Project.all.size }, 1) do
      login_as(FactoryBot.create(:user, :admin))
      post(projects_url,
        params: { project: { name: "hi", description: "lol", export: "true" } }
      )
    end
  end
end
