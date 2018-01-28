class RenamePathToNameOnProjects < ActiveRecord::Migration[5.1]
  def change
    rename_column :projects, :path, :name
    add_index :projects, :name, unique: true
  end
end
