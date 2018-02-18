class ObjectIndexInterface
  def initialize(project:, committish:, path:)
    @project = project
    @committish = committish
    @path = path
  end

  def basename
    File.basename(@path)
  end

  def path_params
    {
      project_name: @project.name,
      reference: @committish,
      path: @path,
    }
  end

  def repo
    @repo ||= @project.repo
  end

  def commit
    @commit ||= DigCommitFromReference.new(repo).call(@committish)
  end

  def object
    @object ||= DigObjectFromCommit.new(repo, commit).call(@path)
  end
end
