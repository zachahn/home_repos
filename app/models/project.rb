class Project < ApplicationRecord
  def name
    @name ||= File.basename(path, ".git")
  end
end
