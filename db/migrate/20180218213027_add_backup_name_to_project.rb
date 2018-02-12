class AddBackupNameToProject < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :backup_name, :string, null: false
  end
end
