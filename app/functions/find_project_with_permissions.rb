class FindProjectWithPermissions
  include ProcParty

  def call(name, user)
    project = Project.find_by!(name: name)

    if !AccessControl.new(project).readable?(user)
      raise ActionController::RoutingError, "Project not found"
    end

    project
  end
end
