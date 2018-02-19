require "test_helper"

class BackupProjectTest < ActiveSupport::TestCase
  def test_it_backs_up
    project =
      FactoryBot.create(:project, name: "one_commit", backup_name: "backup")

    Dir.mktmpdir do |dir|
      backup_repo =
        Rugged::Repository.init_at(File.join(dir, "backup.git"), true)

      BackupProject.new(dir).call(project)

      refute(backup_repo.empty?)
    end
  end
end
