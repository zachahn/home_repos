class CreateProject
  include ProcParty

  def initialize(whitelisted_params)
    @params = whitelisted_params
  end

  def call
    Project.create!(@params) do |project|
      CreateProjectRepository.new.call(project)
    end
  rescue
    DeleteProjectRepository.new.call(fake_project)

    Project.new(@params)
  end

  private

  def fake_project
    OpenStruct.new(
      path: File.join(Root.path, "#{@params[:name]}.git")
    )
  end
end
