require "application_system_test_case"

class GitCloneTest < ApplicationSystemTestCase
  def setup
    # Visiting root_url so that the `current_url` method works
    visit root_url
  end

  def test_cloning_public_repo
    FactoryBot.create(:project, name: "one_commit")

    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        assert(git_clone(git_url("one_commit.git")))
      end
    end
  end

  def test_cloning_private_repo_fails_for_logged_out_user
    FactoryBot.create(:project, :private, name: "one_commit")

    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        # Using a fake username/password here to fail auth without input
        refute(git_clone(git_url("one_commit.git", "x", "y")))
      end
    end
  end

  def test_cloning_private_repo_succeeds_for_logged_in_user
    project = FactoryBot.create(:project, :private, name: "one_commit")
    user = FactoryBot.create(:user, email: "user", password: "pass")
    Permission.create!(user: user, project: project)

    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        assert(git_clone(git_url("one_commit.git", "user", "pass")))
      end
    end
  end

  def test_cloning_nonexistent_repo_requests_auth_and_then_raises_not_found
    FactoryBot.create(:user, email: "user", password: "pass")

    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        output, success =
          git_clone(
            git_url("fake_project.git", "fake", "account"),
            output: true
          )

        refute(success)
        assert_match(/Authentication failed for/, output)

        output, success =
          git_clone(
            git_url("fake_project.git", "user", "pass"),
            output: true
          )

        refute(success)
        assert_match(/remote: Not Found/, output)
      end
    end
  end

  def test_cloning_private_repo_without_permissions_fails
    FactoryBot.create(:project, :private, name: "one_commit")
    FactoryBot.create(:user, email: "user", password: "pass")

    Dir.mktmpdir do |tmpdir|
      Dir.chdir(tmpdir) do
        refute(git_clone(git_url("one_commit.git", "user", "pass")))
      end
    end
  end

  private

  def git_url(repo, user = nil, password = nil)
    uri = URI.parse(current_url)

    uri.user = user if user
    uri.password = password if password

    uri.path = "/#{repo}"

    uri.to_s
  end

  def git_clone(url, output: false)
    stdouterr, status = Open3.capture2e("git", "clone", url)

    if output
      [stdouterr, status.success?]
    else
      status.success?
    end
  end
end
