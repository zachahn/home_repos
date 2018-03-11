class GrackWrapperHelper
  def initialize(env)
    @env = env
  end

  # If the client's request has the HTTP_AUTHORIZATION header, that means that
  # they responded to a HTTP 401 status code.
  def current_user
    @current_user ||=
      if @env.key?("HTTP_AUTHORIZATION")
        decoded_credentials =
          Base64.decode64(@env["HTTP_AUTHORIZATION"][/^Basic (.*)$/, 1])
        email, password = decoded_credentials.split(":")

        login = Login.new(email: email, password: password)
        login.user
      else
        Guest.new
      end
  end

  def current_project
    @current_project ||=
      begin
        project_name_match = @env["REQUEST_PATH"][%r{^/?(.+?)(?=\.git)}, 1]

        if project_name_match
          Project.find_by(name: project_name_match)
        else
          PretendProject.new
        end
      end
  end
end
