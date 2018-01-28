# == Schema Info
#
# Table name: projects
#
#   id            integer     not null, primary key
#   path          string
#   created_at    datetime    not null
#   updated_at    datetime    not null
#   export        boolean
#

class Project < ApplicationRecord
  def name
    @name ||= File.basename(path, ".git")
  end
end
