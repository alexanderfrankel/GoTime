require 'uri'
require 'yajl'

class GoogleDirectionQuery
  def initialize orig_loc, dest_loc, event_time
    @orig_loc = orig_loc
    @dest_loc = dest_loc
    @event_time = event_time
  end

  def get_directions
    parser = Yajl::Parser.new(symbolize_keys: true)
    url = URI.parse(prepare_query)
    result = Net::HTTP.get(url)
    directions = parser.parse(result)
  end

  private

  def prepare_query
    orig_coord = "#{@orig_loc.latitude}, #{@orig_loc.longitude}" 
    dest_coord = "#{@dest_loc.latitude}, #{@dest_loc.longitude}"

    "https://maps.googleapis.com/maps/api/directions/json?origin=#{orig_coord}&destination=#{dest_coord}&key=#{ENV["GOOGLE_API_KEY"]}&arrival_time=#{calculate_arrival_time}&mode=transit"
  end

  def calculate_arrival_time
    arrival_time = DateTime.rfc3339(@event_time) - 5.minutes
    arrival_time.to_i
  end
end
