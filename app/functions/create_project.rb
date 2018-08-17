class CreateProject
  include ProcParty

  def initialize(whitelisted_params, user: nil)
    @params = whitelisted_params
    @user = user || whitelisted_params.delete(:user)
  end

  def call
    Project.transaction do
      project = Project.new(@params)
      project.backup_name = SecureRandom.uuid
      project.save!

      if @user
        project.permissions.create!(user: @user, read: true, write: true)
      end

      CreateProjectRepository.new.call(project)

      project
    end
  rescue
    DeleteProjectRepository.new.call(fake_project)

    Project.new(@params)
  end

  private

  def fake_project
    OpenStruct.new(
      path: File.join(Setting.repositories_path, "#{@params[:name]}.git")
    )
  end
end
