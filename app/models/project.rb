# == Schema Info
#
# Table name: projects
#
#   id             integer     not null, primary key
#   name           string
#   created_at     datetime    not null
#   updated_at     datetime    not null
#   export         boolean
#   description    text
#
# Indices:
#
#   index_projects_on_name    (name)
#

class Project < ApplicationRecord
  validates :name, presence: true, format: /\A[a-zA-Z0-9_-]+\z/

  def path
    File.join(Setting.repositories_path, "#{name}.git")
  end

  def repo
    Rugged::Repository.new(path)
  end

  def to_param
    name
  end
end
