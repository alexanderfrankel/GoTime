class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :appt_id
      t.string :transit_id
      t.references :location
      t.references :user

      t.timestamps
    end
  end
end
