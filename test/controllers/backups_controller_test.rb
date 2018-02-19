require "test_helper"

class BackupsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  def test_must_be_logged_in
    project = FactoryBot.create(:project, name: "two_commits")

    assert_raises(ActionController::RoutingError) do
      post(project_backup_url(project))
    end
  end

  def test_enqueues_a_backup_job
    project = FactoryBot.create(:project, name: "two_commits")
    user = FactoryBot.create(:user, :admin)

    login_as(user)

    assert_enqueued_with(job: BackupProjectJob) do
      post(project_backup_url(project))
    end
  end
end
