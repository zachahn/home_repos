class DetermineProjectCommittishRoot
  include ProcParty

  def call(project, committish)
    repo = project.repo

    if repo.empty?
      return project_path(project)
    end

    main_branch =
      repo.references["HEAD"].target.name[%r{\Arefs/heads/(.*)\z}, 1]

    if main_branch == committish
      return project_path(project)
    end

    project_object_path(project_name: project, reference: committish)
  end

  private

  def project_path(*args)
    Rails.application.routes.url_helpers.project_path(*args)
  end

  def project_object_path(*args)
    Rails.application.routes.url_helpers.project_object_path(*args)
  end
end
