class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :uid
      t.string :provider
      t.string :oauth_token
      t.time :oauth_expires_at

      t.timestamps
    end
  end
end
