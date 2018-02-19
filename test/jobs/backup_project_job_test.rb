require "test_helper"

class BackupProjectJobTest < ActiveJob::TestCase
  def test_pushes_repo
    project =
      FactoryBot.create(:project, name: "one_commit", backup_name: "backup")

    backupper = Minitest::Mock.new
    backupper.expect(:call, nil, [project])

    BackupProject.stub(:new, -> (*) { backupper }) do
      BackupProjectJob.perform_now(project)
    end

    assert_mock(backupper)
  end
end
