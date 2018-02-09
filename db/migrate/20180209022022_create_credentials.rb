class CreateCredentials < ActiveRecord::Migration[5.1]
  def change
    create_view :credentials
  end
end
