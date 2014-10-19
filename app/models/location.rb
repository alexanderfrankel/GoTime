class Location < ActiveRecord::Base
  belongs_to :user
  has_many :orig_events, class_name: 'Event', foreign_key: 'orig_loc'
  has_many :dest_events, class_name: 'Event', foreign_key: 'dest_loc'

  geocoded_by :address  
  after_validation :geocode
end
