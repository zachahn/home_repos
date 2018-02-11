require "test_helper"

class CreateProjectTest < ActiveSupport::TestCase
  def test_successfully_creates_project_and_repo
    creator =
      CreateProject.new(
        name: "lol",
        description: "lolol",
        export: "true"
      )

    creator.call

    created_project = Project.find_by!(name: "lol")
    created_project.repo
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
