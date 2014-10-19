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
	end

	private

	def retrieve_events_with_location
		@user_calendar.retrieve_calendar_events_with_location
	end

	def add_transit_event_to_calendar(appt_event)
		@user_calendar.add_transit_event(appt_event)
	end

end