class AddBackedUpAtToProjects < ActiveRecord::Migration[5.1]
  def change
    add_column :projects, :backed_up_at, :datetime
  end
end
