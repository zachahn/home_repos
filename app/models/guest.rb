class Guest
  include ActiveModel::Model
  include ActiveModel::SecurePassword

  has_secure_password

  def password
  end

  def password=(_new_password)
  end

  def password_digest
    # BCrypt::Password.create(SecureRandom.hex(64))
    "$2a$10$NiXM3y2qMNx3GvV9K50EF..4O7iZn4z4oBPiiY6Wx/Zf43PWZGs9u"
  end
end
