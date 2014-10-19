class EventBuilder
	def initialize(user)
		@user = user
		@user_calendar = GoogleCalendar.new(user)
	end

	def add_initial_appts_and_transit_events_to_database
		retrieve_events_with_location.each do |appt_event|

			event = Event.new
			event.location = Location.create(address: appt_event.location)
			event.appt_id = appt_event.id
			event.user = @user
			event.save

			transit_directions = get_transit_directions(@user.location, event.location, appt_event.start["dateTime"])

			transit_event = add_transit_event_to_calendar(appt_event, transit_directions, @parsed_time)

			event.transit_id = transit_event.id
			event.save
		end
		save_sync_token
	end

	def add_incremental_appts_and_transit_events_to_database
		incremental_retrieve_events_with_location.each do |appt_event|
			puts
			puts "NEW EVENT!!!!!!!!"
			puts
			puts
		end
	end

	def watch_user_calendar_for_event_changes
		response = @user_calendar.initiate_user_calendar_watch
		save_channel_id(JSON[response.body]["id"])
		save_resource_id(JSON[response.body]["resourceId"])
	end

	def disable_watch_user_calendar_for_event_changes
		@user_calendar.disable_user_calendar_watch(@user.channel_id, @user.resource_id)
		remove_channel_id
		remove_resource_id
	end

	def remove_all_user_events
		Event.destroy_all(user_id: @user.id)
	end


	private

	def initial_retrieve_events_with_location
		@user_calendar.initial_retrieve_calendar_events_with_location
	end

	def incremental_retrieve_events_with_location
		@user_calendar.incremental_retrieve_calendar_events_with_location
	end

	def add_transit_event_to_calendar(appt_event, transit_directions, parsed_time)
		@user_calendar.add_transit_event(appt_event, transit_directions, parsed_time)
	end

	def save_sync_token
		@user.sync_token = @user_calendar.sync_token
		@user.save
	end

	def save_channel_id(id)
		@user.channel_id = id
		@user.save
	end

	def remove_channel_id
		@user.channel_id = nil
		@user.save
	end

	def save_resource_id(id)
		@user.resource_id = id
		@user.save
	end

	def remove_resource_id
		@user.resource_id = nil
		@user.save

	# def format_event_time(appt_event)
	# 	DateTime.rfc3339(appt_event.start["dateTime"])
	# end

	def get_transit_directions(orig_loc, dest_loc, event_time)
		directions = GoogleDirectionQuery.new(orig_loc, dest_loc, event_time).get_directions
		parser = GoogleDirectionParser.new(directions)
		@parsed_time = parser.parse_time
		parser.parse_directions
	end
end
