class ProjectsController < ApplicationController
  def index
    @projects = Project.where(export: true)
  end
end
