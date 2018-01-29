class ObjectsController < ApplicationController
  def show
    @project =
      FindProjectWithPermissions.new.call(params[:project_name], current_user)

    repo = @project.repo

    commit = DigCommitFromReference.new(repo).call(params[:reference])

    @object = DigObjectFromCommit.new(repo, commit).call(params[:path])
  end
end
