class AddSyncTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sync_token, :string, default: nil
  end
end
