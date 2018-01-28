class ProjectsController < ApplicationController
  def index
    @projects =
      if current_user.admin?
        Project.all
      else
        Project.where(export: true)
      end
  end
end
