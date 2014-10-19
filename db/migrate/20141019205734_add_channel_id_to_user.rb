class AddChannelIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :channel_id, :string, default: nil
  end
end
