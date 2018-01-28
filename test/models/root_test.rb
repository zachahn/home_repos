require "test_helper"

class RootTest < ActiveSupport::TestCase
  def test_path
    assert_equal(Rails.root.join("tmp/test_repos").to_s, Root.path)
  end
end
