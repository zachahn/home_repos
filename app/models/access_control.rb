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

    false
  end
end
