require "test_helper"

class BranchesControllerTest < ActionDispatch::IntegrationTest
  def test_branches_index_lists_all_branches
    project = FactoryBot.create(:project, name: "two_branches")
    get(project_branches_path(project, "two_branches"))

    assert_equal(200, response.status)
    assert_match(/\bsecond_branch\b/, response.body)
    assert_match(/\bmaster\b/, response.body)
  end

  def test_branches_index_lists_all_branches_even_if_none_exist
    project = FactoryBot.create(:project, name: "zero_commits")
    get(project_branches_path(project, "zero_commits"))

    assert_equal(200, response.status)
  end
end
