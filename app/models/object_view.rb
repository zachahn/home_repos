class ObjectView
  def initialize(project:, committish:, path:)
    @project = project
    @committish = committish
    @path = path || ""
  end

  attr_reader :committish
  attr_reader :path
  attr_reader :project

  def breadcrumb
    @breadcrumb ||=
      Breadcrumb.new(
        project: @project,
        path: @path,
        committish: @committish
      )
  end

  def blob
    @blob ||=
      ObjectBlob.new(
        project: project,
        committish: committish,
        path: path
      )
  end

  def tree
    @tree ||=
      ObjectTree.new(
        project: project,
        committish: committish,
        path: path
      )
  end

  def commit
    @commit ||= DigCommitFromReference.new(repo).call(@committish)
  end

  def object
    @object ||= DigObjectFromCommit.new(repo, commit).call(@path)
  end

  def repo
    @repo ||= @project.repo
  end

  def to_partial_path
    if repo.empty?
      return "objects/empty"
    end

    "objects/#{object.type}"
  end
end
