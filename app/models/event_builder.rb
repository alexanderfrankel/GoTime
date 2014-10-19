class EventBuilder
	def initialize(user)
		@user = user
		@user_calendar = GoogleCalendar.new(user)
	end

	def add_appts_and_transit_events_to_database
		retrieve_events_with_location.each do |appt_event|
			
		event = Event.new
		event.dest_loc = save_dest_location
		event.appt_id = appt_event.id
		event.user = @user
		event.save

		transit_directions = get_transit_directions(event.orig_loc, event.dest_loc, format_event_time(appt_event))

		transit_event = add_transit_event_to_calendar(appt_event, transit_directions, @parsed_time)

		event.transit_id = transit_event.id
		event.save
		end
		save_sync_token
	end

	private

	def retrieve_events_with_location
		@user_calendar.retrieve_calendar_events_with_location
	end

	def add_transit_event_to_calendar(appt_event)
		@user_calendar.add_transit_event(appt_event)
	end

	def save_sync_token
		@user.sync_token = @user_calendar.sync_token
		@user.save
	end

	def format_event_time(appt_event)
		DateTime.rfc3339(appt_event.start["dateTime"])
	end

	def save_dest_location(appt_event)
		Location.create(appt_event.location)
	end

	def get_transit_directions(orig_loc, dest_loc, event_time)
		directions = GoogleDirectionQuery.new(orig_loc, dest_loc, event_time)
		parser = GoogleDirectionParser.new(directions)
		@parsed_time = parser.parse_time
		parser.parse_directions
	end
end
