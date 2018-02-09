# == Schema Info
#
# Table name: credentials
#
#   user_id            integer
#   email              string
#   password_digest    string
#

class Credential < ApplicationRecord
  has_secure_password

  def readonly?
    true
  end
end
