class AddLocationsToEvents < ActiveRecord::Migration
  def change
    add_reference :events, :orig_loc
    add_reference :events, :dest_loc
  end
end
