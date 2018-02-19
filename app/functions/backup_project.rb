class BackupProject
  include ProcParty

  def initialize(backups_root = Setting.backups_root)
    @backups_root = backups_root
  end

  def call(project)
    Dir.chdir(repository_path(project)) do
      output, status = git_push_mirror(project)

      if status.success?
        denote_successful_backup(project)
        Rails.logger.info(output)
      else
        Rails.logger.error(output)
      end

      status.success?
    end
  end

  private

  def git_push_mirror(project)
    Open3.capture2e("git", "push", "--mirror", backup_path(project))
  end

  def denote_successful_backup(project)
    project.update(backed_up_at: Time.current)
  end

  def repository_path(project)
    File.join(Setting.repositories_path, "#{project.name}.git")
  end

  def backup_path(project)
    File.join(@backups_root, "#{project.backup_name}.git")
  end
end
