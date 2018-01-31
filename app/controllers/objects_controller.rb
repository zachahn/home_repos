class ObjectsController < ApplicationController
  def show
    project =
      FindProjectWithPermissions.new.call(params[:project_name], current_user)

    @object_view = ObjectView.new(
      project: project,
      committish: params[:reference],
      path: params[:path]
    )
  end
end
