class AddResourceIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :resource_id, :string, default: nil
  end
end
