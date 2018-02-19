class Setting
  def self.repositories_path
    root = ENV.fetch("REPOS_ROOT_PATH")
    File.expand_path(root, Rails.root.to_s)
  end

  def self.backups_root
    ENV.fetch("BACKUPS_ROOT_PATH")
  end
end
