class Location < ActiveRecord::Base
  belongs_to :locationable, polymorphic: true

  geocoded_by :address  
  after_validation :geocode
end
