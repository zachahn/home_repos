require "test_helper"

class FilesControllerTest < ActionDispatch::IntegrationTest
  def test_redirects_to_default_branch
    project = FactoryBot.create(:project, name: "two_branches")
    get(project_files_path(project))
    assert_redirected_to(controller: "files", action: "show", committish: "master")
  end

  def test_redirects_to_default_branch_if_empty_repo
    project = FactoryBot.create(:project, name: "zero_commits")
    get(project_files_path(project))
    assert_redirected_to(controller: "files", action: "show", committish: "master")
  end

  def test_lists_all_files_of_master_branch
    project = FactoryBot.create(:project, name: "two_branches")
    get(project_file_path(project, "master"))
    assert_equal(200, response.status)
    assert_match(/\bREADME\.md\b/, response.body)
    assert_match(/\bREAD_ME_TOO\.md\b/, response.body)
  end

  def test_lists_all_files_of_non_master_branch
    project = FactoryBot.create(:project, name: "two_branches")
    get(project_file_path(project, "second_branch"))
    assert_equal(200, response.status)
    assert_match(/\bREADME\.md\b/, response.body)
    assert_match(/\bCONTRIBUTING\.md\b/, response.body)
  end
end
