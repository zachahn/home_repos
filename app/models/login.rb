class Login
  include ActiveModel::Model

  attr_accessor :email
  attr_accessor :password

  def initialize(email: nil, password: nil)
    @email = email
    @password = password
  end

  def user
    @user ||=
      if authenticate?
        User.find_by(email: @email)
      else
        Guest.new
      end
  end

  def authenticate?
    if @authenticated.nil?
      @authenticated = credentials.any? { |c| c.authenticate(@password) }
    end

    @authenticated
  end

  def credentials
    @credentials ||= Credential.where(email: @email)
  end
end
