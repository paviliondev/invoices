class AddGroupsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :groups, :string
  end
end
