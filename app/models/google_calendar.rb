class GoogleCalendar
	attr_reader :sync_token

	def initialize(current_user)
		@current_user = current_user
		@client = Google::APIClient.new
		@client.authorization.access_token = @current_user.oauth_token
		@service = @client.discovered_api('calendar', 'v3')
	end

	def retrieve_calendar_events_with_location
		options = {
		  :api_method => @service.events.list,
		  :parameters => {"calendarId" => @current_user.email,
		  								"timeMin" => DateTime.now.xmlschema},
		  :headers    => {"Content-Type" => "application/json"}
		}

		calendar_events = @client.execute(options).data
		@sync_token = calendar_events.nextSyncToken

		@calendar_events_with_location = events_with_location(calendar_events.items)
	end

	def add_transit_event(appt_event, transit_directions, event_times)
		
		transit_event_start_time = event_times[:departure_time]

		transit_event_end_time = event_times[:arrival_time]

		event = { 'summary' => 'IN TRANSIT',
							'description' => transit_directions,
							'start' => {'dateTime' => transit_event_start_time},
							'end' => {'dateTime' => transit_event_end_time} }

		options = {
			:api_method => @service.events.insert,
			:parameters => {'calendarId' => @current_user.email},
			:body => JSON.dump(event),
			:headers => {'Content-Type' => 'application/json'}
		}

		@client.execute(options).data
	end

	# def calendar_watch
	# 	options = {
	# 		:api_method => @service.events.watch,
	# 		:parameters => {"calendarId" => @current_user.email},
	# 		:body => JSON.dump({id: "cbi4vk1XUqBEX2Y2oK35Og",
	# 												type: "web_hook",
	# 												address: "https://42672916.ngrok.com/google_notifications"}),
	# 		:headers => {'Content-Type' => 'application/json'}
	# 	}

	# 	@client.execute(options)
	# end

	# def calendar_watch_stop
	# 	options = {
	# 		:api_method => @service.channels.stop,
	# 		:parameters => {"calendarId" => @current_user.email},
	# 		:body => JSON.dump({id: "my-unique-id-0001",
	# 												resourceId:"gMe_fTErHb1mENwtlscj7zWWRzI"}),
	# 		:headers => {'Content-Type' => 'application/json'}
	# 	}
	# end

	private

	def events_with_location(events)
		events_with_location = []
		events.each do |event|
			events_with_location << event if event.location
		end
		events_with_location
	end
end
