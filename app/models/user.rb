# == Schema Info
#
# Table name: users
#
#   id                 integer     not null, primary key
#   email              string
#   password_digest    string
#   expires_at         datetime
#   created_at         datetime    not null
#   updated_at         datetime    not null
#   admin              boolean
#

class User < ApplicationRecord
  has_secure_password

  has_many :permissions

  def user?
    true
  end
end
