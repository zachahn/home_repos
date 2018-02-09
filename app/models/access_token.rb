# == Schema Info
#
# Table name: access_tokens
#
#   id                 integer     not null, primary key
#   user_id            integer
#   password_digest    string
#   created_at         datetime    not null
#   updated_at         datetime    not null
#
# Indices:
#
#   index_access_tokens_on_user_id    (user_id)
#

class AccessToken < ApplicationRecord
  belongs_to :user

  has_secure_password
end
