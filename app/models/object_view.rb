class ObjectView
  def initialize(project:, committish:, path:)
    @project = project
    @committish = committish
    @path = path || ""
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

  def content
    object.content
  end

  def each_tree_item
    object.each_tree do |tree|
      yield(obj_hash(tree))
    end

    object.each_blob do |blob|
      yield(obj_hash(blob))
    end
  end

  def to_partial_path
    if repo.empty?
      return "objects/empty"
    end

    "objects/#{object.type}"
  end

  def obj_hash(obj)
    {
      type: obj[:type],
      name: obj[:name],
      path_params: {
        project_name: @project.name,
        reference: @committish,
        path: obj_fullpath(obj[:name]),
      },
    }
  end

  private

  def obj_fullpath(basename)
    if @path == ""
      basename
    else
      File.join(@path, basename)
    end
  end
end
