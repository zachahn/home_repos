class DeleteProjectRepository
  def call(project)
    if File.directory?(project.path)
      FileUtils.remove_entry_secure(project.path, true)
    end
  end
end
