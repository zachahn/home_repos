require "test_helper"

class CreateProjectTest < ActiveSupport::TestCase
  def test_successfully_creates_project_and_repo_and_permission
    user = FactoryBot.create(:user)

    creator =
      CreateProject.new(
        name: "lol",
        description: "lolol",
        export: "true",
        user: user
      )

    creator.call

    created_project = Project.find_by!(name: "lol")
    assert_kind_of(Rugged::Repository, created_project.repo)
    assert_equal(user, created_project.permissions.first.user)
  end

  def test_deletes_project_if_creation_fails
    CreateProjectRepository.stub(:new, -> { raise "testing" }) do
      creator =
        CreateProject.new(
          name: "lol",
          description: "lolol",
          export: "true"
        )

      creator.call
    end

    assert_nil(Project.find_by(name: "lol"))
    refute(File.exist?(File.join(Setting.repositories_path, "lol.git")))
  end
end
