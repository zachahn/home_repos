class CreateAccessTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :access_tokens do |t|
      t.references :user, foreign_key: true
      t.string :password_digest

      t.timestamps
    end
  end
end
