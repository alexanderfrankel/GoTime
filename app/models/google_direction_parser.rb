class GoogleDirectionParser
  def initialize directions
    @directions = directions["routes"][0]["legs"][0]
    @parsed_directions = []
  end

  def parse_time
    arrival_time = Time.at(@directions["arrival_time"]["value"]).xmlschema
    departure_time = Time.at(@directions["departure_time"]["value"]).xmlschema

    @times = { arrival_time: arrival_time,
               departure_time: departure_time }
  end

  def parse_directions
    # count = 0
    # @directions[:steps].each do |route|
    #   count += 1
    #   @parsed_directions[count] = []
    #   @parsed_directions[count] << route[:html_instructions]
    #   # if route[:steps][0][:travel_mode] == "TRANSIT"
    #   #   route[:steps][0].each do |step|
    #   #     @parsed_directions << step[:html_directions]
    #   #   end
    #   # else
    #   @directions[:steps][count][:steps].each do |step|
    #     step[:html_directions]
    #   end
    # end
    # @parsed_directions
    #
    parse_subway
  end

  def parse_subway
    subway_info = @directions["steps"][1]["transit_details"]
    parsed_directions = "Take the #{subway_info["line"]["short_name"]} towards #{subway_info["headsign"]} from #{subway_info["departure_stop"]["name"]} departing at #{subway_info["departure_time"]["text"]}. Get off at #{subway_info["arrival_stop"]["name"]} at #{subway_info["arrival_stop"]["name"]}."
  end
end