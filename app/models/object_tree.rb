class ObjectTree
  def initialize(project:, committish:, path:)
    @project = project
    @committish = committish
    @path = path
  end

  def each_object
    object.each_tree do |tree|
      yield(obj_hash(tree))
    end

    object.each_blob do |blob|
      object_data = obj_hash(blob)
      yield(object_data)
    end
  end

  def obj_hash(obj)
    {
      type: obj[:type],
      icon: obj_icon(obj[:type]),
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

  def obj_icon(type)
    if type == :blob
      "file"
    else
      "folder"
    end
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
