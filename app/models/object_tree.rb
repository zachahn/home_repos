class ObjectTree
  def initialize(project:, committish:, path:)
    @project = project
    @committish = committish
    @path = path
    @readme = nil
    @index_interface =
      ObjectIndexInterface.new(
        project: @project,
        committish: @committish,
        path: @path
      )
  end

  delegate :basename, to: :@index_interface
  delegate :path_params, to: :@index_interface
  delegate :object, to: :@index_interface

  attr_reader :readme

  def icon
    "folder"
  end

  def each_object
    object.each_tree do |tree|
      yield(object_representation(tree))
    end

    object.each_blob do |blob|
      object_data = object_representation(blob)
      yield(object_data)

      @readme ||= check_if_readme(object_data)
    end
  end

  def object_representation(obj)
    klass = type_to_class(obj[:type])

    klass.new(
      project: @project,
      committish: @committish,
      path: compute_fullpath(obj[:name])
    )
  end

  private

  def check_if_readme(object_data)
    if object_data.basename =~ /\breadme\b/i
      object_data
    end
  end

  def type_to_class(type)
    if type == :blob
      ObjectBlob
    else
      ObjectTree
    end
  end

  def compute_fullpath(child)
    if @path == ""
      child
    else
      File.join(@path, child)
    end
  end
end
