Settings =
  CustomSettings.new(
    defaults: Rails.root.join("config", "defaults.yml"),
    settings: Rails.root.join("config", "settings.yml")
  )
