class AccessControl
  def initialize(project)
    @project = project
  end

  def writable?(user)
    if user.admin?
      return true
    end

    if user.permissions.where(project: @project, write: true).any?
      return true
    end

    false
  end

  def readable?(user)
    if user.admin?
      return true
    end

    if @project.export
      return true
    end

    if user.permissions.where(project: @project, read: true).any?
      return true
    end

    false
  end
end
