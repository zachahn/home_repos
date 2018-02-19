class BackupsController < ApplicationController
  before_action :admins_only

  def create
    project = Project.find_by!(name: params[:project_name])

    BackupProjectJob.perform_later(project)

    flash.notice = "Scheduled backup for #{project.name}"
    redirect_back(fallback_location: root_path)
  end
end
