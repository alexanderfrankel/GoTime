class EventBuilder
	def initialize(user)
		@user = user
		@user_calendar = GoogleCalendar.new(user)
	end

	def add_appts_and_transit_events_to_database
		retrieve_events_with_location.each do |appt_event|
			Event.create(appt_id: appt_event.id,
								transit_id: add_transit_event_to_calendar(appt_event).id,
								user_id: @user.id)
		end
		save_sync_token
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
	end
end
