class AddExportToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :export, :boolean
  end
end
