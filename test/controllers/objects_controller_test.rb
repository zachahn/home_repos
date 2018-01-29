require "test_helper"

class ObjectsControllerTest < ActionDispatch::IntegrationTest
  def test_top_level_blob
    FactoryBot.create(:project, name: "two_commits")
    object_url = project_object_url(
      project_name: "two_commits",
      reference: "master",
      path: "README.md"
    )

    get(object_url)

    assert_response(:success)
    assert_match(/Woo!/, @response.body)
  end

  def test_nested_blob
    FactoryBot.create(:project, name: "two_commits")
    object_url = project_object_url(
      project_name: "two_commits",
      reference: "master",
      path: "subdir/README.txt"
    )

    get(object_url)

    assert_response(:success)
    assert_match(/More reading material!/, @response.body)
  end

  def test_top_level_tree
    FactoryBot.create(:project, name: "two_commits")
    object_url = project_object_url(
      project_name: "two_commits",
      reference: "master",
      path: ""
    )

    get(object_url)

    assert_response(:success)
    assert_match(/README\.md/, @response.body)
  end

  def test_nested_tree
    FactoryBot.create(:project, name: "two_commits")
    object_url = project_object_url(
      project_name: "two_commits",
      reference: "master",
      path: "subdir"
    )

    get(object_url)

    assert_response(:success)
    assert_match(/README\.txt/, @response.body)
  end
end
