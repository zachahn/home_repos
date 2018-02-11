require "test_helper"

class SettingTest < ActiveSupport::TestCase
  def test_repositories_path
    assert_equal(
      Rails.root.join("tmp/test_repos").to_s,
      Setting.repositories_path
    )
  end
end
