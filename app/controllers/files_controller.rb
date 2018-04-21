class FilesController < ApplicationController
  def index
    default_branch = ExtractDefaultBranchFromRepo.new.call(project.repo)
    redirect_to project_file_path(project, default_branch)
  end

  def show
    @filenames =
      ListAllFilesUnderTreeish.new(project.repo).call(params[:committish])
  end

  private

  def project
    @project ||=
      FindProjectWithPermissions.new.call(params[:project_name], current_user)
  end
end
