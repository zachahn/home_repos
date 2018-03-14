require "application_system_test_case"

class GitHttpInterfaceExportedTest < ApplicationSystemTestCase
  def setup
    # Visiting root_url so that the `current_url` method works
    visit root_url

    @project = FactoryBot.create(:project, name: "one_commit")
    @private_reset_point = @project.repo.head.target.oid

    @private_current_directory = Dir.pwd
    @private_tmpdir = Dir.mktmpdir
    Dir.chdir(@private_tmpdir)
  end

  def teardown
    Dir.chdir(@private_current_directory)
    FileUtils.remove_entry(@private_tmpdir)

    @project.repo.reset(@private_reset_point, :soft)
  end

  def test_admins_can_read_and_write
    FactoryBot.create(:user, :admin, email: "admin", password: "p")

    assert(
      git_clone(git_url("one_commit.git", "admin", "p")),
      "Admins should be able to clone public repos"
    )

    assert(
      push_a_change_on("one_commit"),
      "Admins should be able to push to public repos"
    )
  end

  def test_permitted_user_can_read_and_write
    user = FactoryBot.create(:user, email: "user", password: "p")
    Permission.create!(user: user, project: @project, read: true, write: true)

    assert(
      git_clone(git_url("one_commit.git", "user", "p")),
      "Permitted users should be able to clone public repos"
    )

    assert(
      push_a_change_on("one_commit"),
      "Permitted users should be able to push to public repos"
    )
  end

  def test_unpermitted_user_cannot_read_or_write
    FactoryBot.create(:user, email: "user", password: "p")

    assert(
      git_clone(git_url("one_commit.git", "user", "p")),
      "Unpermitted users should be able to clone public repos"
    )

    refute(
      push_a_change_on("one_commit"),
      "Unpermitted users shouldn't be able to push to public repos"
    )
  end

  def test_guest_cannot_read_or_write
    # Using nonexistent creds to bypass login prompt
    assert(
      git_clone(git_url("one_commit.git", "doesnt", "exist")),
      "Unpermitted users should be able to clone public repos"
    )

    refute(
      push_a_change_on("one_commit"),
      "Unpermitted users shouldn't be able to push to public repos"
    )
  end

  private

  def push_a_change_on(directory)
    Dir.chdir(directory) do
      File.write("YOLO", "YOLO\n")
      git_add_and_commit("My Cool Commit")

      git_push
    end
  end

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

  def git_push(output: false)
    stdouterr, status = Open3.capture2e("git", "push")

    if output
      [stdouterr, status.success?]
    else
      status.success?
    end
  end

  def git_add_and_commit(message)
    Open3.capture2e("git", "add", ".")
    Open3.capture2e("git", "commit", "-m", message)
  end

  def take_failed_screenshot
    false
  end
end
