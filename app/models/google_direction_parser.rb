class GoogleDirectionParser
  def initialize directions
    @directions = directions[:routes][0][:legs][0]
    @parsed_directions = []
  end

  def parse_time
    arrival_time = Time.at(@directions[:arrival_time][:value]).xmlschema
    departure_time = Time.at(@directions[:departure_time][:value]).xmlschema

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
    "Directions go here"
  end
end