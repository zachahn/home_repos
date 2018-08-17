class ProjectsController < ApplicationController
  def index
    @projects =
      if current_user.admin?
        Project.all
      elsif current_user.user?
        Project.joins(:permissions)
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

  def new
    if !current_user.admin?
      redirect_to root_path, alert: "Access denied"
      return
    end

    @project = Project.new
  end

  def create
    if !current_user.admin?
      redirect_to root_path, alert: "Access denied"
      return
    end

    @project = CreateProject.new(project_params).call

    if @project.persisted?
      redirect_to(@project)
    else
      render :new
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :description, :export)
  end
end
