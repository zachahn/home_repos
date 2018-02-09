class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions do |t|
      t.references :user, foreign_key: true
      t.references :project, foreign_key: true
      t.boolean :read, null: false, default: true
      t.boolean :write, null: false, default: false

      t.timestamps
    end
  end
end
