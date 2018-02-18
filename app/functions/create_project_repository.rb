class CreateProjectRepository
  def call(project)
    if !File.directory?(project.path)
      Rugged::Repository.init_at(project.path, :bare)
    end
  end
end
