class Event < ActiveRecord::Base
	belongs_to :user
  belongs_to :orig_loc, class_name: "Location"
  belongs_to :dest_loc, class_name: "Location"
end