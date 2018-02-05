class GrackWrapper
  def call(env)
    @env = env
    @user = logging_in_user(env) || Guest.new
    @project = requested_project(env) || PretendProject.new

    app.call(env)
  end

  private

  def app
    project = @project
    authenticated = @user.is_a?(User)
    grack = grack_build

    Rack::Builder.app do
      if !project.export
        use(Rack::Auth::Basic, "HomeRepos") { |_, _| authenticated }
      end

      run grack
    end
  end

  def grack_build
    access_control = AccessControl.new(@project)

    Grack::App.new(
      root: Root.path,
      allow_push: access_control.writable?(@user),
      allow_pull: access_control.readable?(@user),
      git_adapter_factory: -> { Grack::GitAdapter.new }
    )
  end

  def requested_project(env)
    project_name_match = env["REQUEST_PATH"][%r{^/?(.+?)(?=\.git)}, 1]

    if project_name_match
      Project.find_by(name: project_name_match)
    end
  end

  def logging_in_user(env)
    if env.key?("HTTP_AUTHORIZATION")
      decoded_credentials =
        Base64.decode64(env["HTTP_AUTHORIZATION"][/^Basic (.*)$/, 1])
      email, password = decoded_credentials.split(":")

      login = Login.new(email: email, password: password)
      login.user
    end
  end
end
