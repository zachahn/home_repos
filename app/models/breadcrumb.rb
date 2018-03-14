class Breadcrumb
  def initialize(project:, path:, committish:)
    @project = project
    @path = path
    @committish = committish
  end

  def project_root
    link_to(
      @project.name,
      DetermineProjectCommittishRoot.new.call(@project, @committish)
    )
  end

  def each
    common = { project_name: @project.name, reference: @committish }
    grown = []

    path_components[0..-2].each do |part|
      current_path = grown.push(part).join("/")

      yield(link_to(part, project_object_path(**common, path: current_path)))
    end

    if path_components.last
      yield path_components.last
    end
  end

  private

  def path_components
    @path_components ||= @path.split("/")
  end

  def link_to(*args)
    ActionController::Base.helpers.link_to(*args)
  end

  def project_object_path(*args)
    Rails.application.routes.url_helpers.project_object_path(*args)
  end

  def project_path(*args)
    Rails.application.routes.url_helpers.project_path(*args)
  end
end
