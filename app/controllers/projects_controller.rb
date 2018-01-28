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
    @project = Project.find_by(name: params[:name])

    if !AccessControl.new(@project).readable?(current_user)
      raise ActionController::RoutingError, "Project not found"
    end

    head :ok
  end
end
