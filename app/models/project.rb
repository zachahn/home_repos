# == Schema Info
#
# Table name: projects
#
#   id            integer     not null, primary key
#   name          string
#   created_at    datetime    not null
#   updated_at    datetime    not null
#   export        boolean
#
# Indices:
#
#   index_projects_on_name    (name)
#

class Project < ApplicationRecord
  def path
    File.join(Root.path, "#{name}.git")
  end

  def repo
    Rugged::Repository.new(path)
  end

  def to_param
    name
  end
end
