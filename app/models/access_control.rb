class AccessControl
  def initialize(project)
    @project = project
  end

  def readable?(user)
    if user.admin?
      return true
    end

    if @project.export
      return true
    end

    if user.permissions.where(project: @project, read: true)
      return true
    end

    false
  end
end
