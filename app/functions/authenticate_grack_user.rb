class AuthenticateGrackUser
  include ProcParty

  def call(username, password)
    login = Login.new(email: email, password: password)
    login.user
  end
end
