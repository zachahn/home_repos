class GrackWrapper
  def call(env)
    app =
      Grack::App.new(
        root: Setting.repositories_path,
        allow_push: true,
        allow_pull: true,
        git_adapter_factory: -> { Grack::GitAdapter.new },
        middleware: GrackAuthMiddleware
      )

    app.call(env)
  end
end
