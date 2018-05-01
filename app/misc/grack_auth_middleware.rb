class GrackAuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    helper = GrackWrapperHelper.new(env)
    access_control = AccessControl.new(helper.current_project)

    if helper.current_project.export
      if env["grack.direction"] == :pull
        return @app.call(env)
      elsif env["grack.direction"] == :push
        if access_control.writable?(helper.current_user)
          return @app.call(env)
        end

        if helper.current_user.is_a?(User)
          return not_found
        end

        return please_authenticate
      end
    else
      if env["grack.direction"] == :pull
        if access_control.readable?(helper.current_user)
          return @app.call(env)
        end
      elsif env["grack.direction"] == :push
        if access_control.writable?(helper.current_user)
          return @app.call(env)
        end
      end

      if helper.current_user.is_a?(User)
        return not_found
      else
        return please_authenticate
      end
    end
  end

  private

  def not_found
    headers = {
      "Content-Type" => "text/plain",
    }

    [404, headers, ["Not found"]]
  end

  def please_authenticate
    headers = {
      "Content-Type" => "text/plain",
      "WWW-Authenticate" => "Basic realm=HomeRepos",
    }

    [401, headers, ["Unauthorized"]]
  end
end
