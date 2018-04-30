class FilesController < ApplicationController
  def index
    default_branch = ExtractDefaultBranchFromRepo.new.call(project.repo)
    redirect_to project_file_path(project, default_branch)
  end

  def show
    lister = ListAllFilesUnderTreeish.new(project.repo)
    @filenames = lister.call(params[:committish]).map do |path|
      {
        name: path,
        link: project_object_path(project, params[:committish], path),
      }
    end
  end

  private

  def project
    @project ||=
      FindProjectWithPermissions.new.call(params[:project_name], current_user)
  end
end
