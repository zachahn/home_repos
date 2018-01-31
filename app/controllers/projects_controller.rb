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
    project =
      FindProjectWithPermissions.new.call(params[:name], current_user)

    @object_view = ObjectView.new(
      project: project,
      committish: "master",
      path: nil
    )

    render "objects/show"
  end
end
