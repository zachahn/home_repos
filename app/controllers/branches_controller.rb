class BranchesController < ApplicationController
  def index
    @branches =
      project.repo.branches.each_name(:local).sort.map do |branch|
        {
          name: branch,
          link: DetermineProjectCommittishRoot.new.call(project, branch),
        }
      end
  end

  private

  def project
    @project ||=
      FindProjectWithPermissions.new.call(params[:project_name], current_user)
  end
end
