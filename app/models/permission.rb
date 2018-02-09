# == Schema Info
#
# Table name: permissions
#
#   id            integer     not null, primary key
#   user_id       integer
#   project_id    integer
#   read          boolean     not null, default (true)
#   write         boolean     not null, default (false)
#   created_at    datetime    not null
#   updated_at    datetime    not null
#
# Indices:
#
#   index_permissions_on_project_id    (project_id)
#   index_permissions_on_user_id       (user_id)
#

class Permission < ApplicationRecord
  belongs_to :user
  belongs_to :project
end
