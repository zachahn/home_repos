class GrackAuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    helper = GrackWrapperHelper.new(env)
    access_control = AccessControl.new(helper.current_project)

    if env["grack.direction"] == :pull
      handle_pulls(helper, access_control, @app, env)
    elsif env["grack.direction"] == :push
      handle_pushes(helper, access_control, @app, env)
    end
  end

  private

  def handle_pulls(helper, access_control, app, env)
    if helper.current_project.export
      return app.call(env)
    else
      if access_control.readable?(helper.current_user)
        return app.call(env)
      end
    end

    handle_unauthorized(helper)
  end

  def handle_pushes(helper, access_control, app, env)
    if access_control.writable?(helper.current_user)
      return app.call(env)
    end

    handle_unauthorized(helper)
  end

  def handle_unauthorized(helper)
    if helper.current_user.is_a?(User)
      return not_found
    end

    please_authenticate
  end

  def not_found
    headers = {
      "Content-Type" => "text/plain",
    }

    [404, headers, ["Not found"]]
  end

  def please_authenticate
    headers = {
      "Content-Type" => "text/plain",
      "WWW-Authenticate" => "Basic realm=#{Settings.site_name}",
    }

    [401, headers, ["Unauthorized"]]
  end
end
