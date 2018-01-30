class ProjectsController < ApplicationController
  def index
    @projects =
      if current_user.admin?
        Project.all
      else
        Project.where(export: true)
      end
  end

  def show
    @project =
      FindProjectWithPermissions.new.call(params[:name], current_user)

    @object = @project.repo.branches["master"].target.tree

    render "objects/show"
  end
end
