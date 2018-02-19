class BackupProjectJob < ApplicationJob
  queue_as :default

  attr_writer :backups_root

  def backups_root
    @backups_root ||= Setting.backups_root
  end

  def perform(project)
    backerupper = BackupProject.new(@backups_root)
    backerupper.call(project)
  end
end
