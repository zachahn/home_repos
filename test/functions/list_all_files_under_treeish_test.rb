require "test_helper"

class ListAllFilesUnderTreeishTest < ActiveSupport::TestCase
  def test_lists_all_files_recursively
    project = FactoryBot.create(:project, name: "two_commits")
    filenames = ListAllFilesUnderTreeish.new(project.repo).call("master")

    assert_includes(filenames, "subdir/README.txt")
    assert_includes(filenames, "README.md")
  end
end
