class GoogleCalendar
	attr_reader :sync_token

	WEB_HOOK_ADDRESS = "https://42672916.ngrok.com/google_notifications"

	def initialize(user)
		@user = user
		@client = Google::APIClient.new
		@client.authorization.access_token = @user.oauth_token
		@service = @client.discovered_api('calendar', 'v3')
		@channel_id = SecureRandom.uuid
	end

	def initial_retrieve_calendar_events_with_location
		options = {
		  :api_method => @service.events.list,
		  :parameters => {"calendarId" => @user.email,
		  								"timeMin" => DateTime.now.xmlschema},
		  :headers    => {"Content-Type" => "application/json"}
		}

		calendar_events = @client.execute(options).data
		@sync_token = calendar_events.nextSyncToken

		@calendar_events_with_location = events_with_location(calendar_events.items)
	end

	def incremental_retrieve_calendar_events_with_location
		options = {
		  :api_method => @service.events.list,
		  :parameters => {"calendarId" => @user.email,
		  								"syncToken" => @user.sync_token},
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
			:parameters => {'calendarId' => @user.email},
			:body => JSON.dump(event),
			:headers => {'Content-Type' => 'application/json'}
		}

		@client.execute(options).data
	end

	def initiate_user_calendar_watch
		options = {
			:api_method => @service.events.watch,
			:parameters => {"calendarId" => @user.email},
			:body => JSON.dump({id: @channel_id,
													type: "web_hook",
													address: WEB_HOOK_ADDRESS}),
			:headers => {'Content-Type' => 'application/json'}
		}

		@client.execute(options)
	end

	def disable_user_calendar_watch(user_channel_id, user_resource_id)
		options = {
			:api_method => @service.channels.stop,
			:body => JSON.dump({id: user_channel_id,
													resourceId: user_resource_id}),
			:headers => {'Content-Type' => 'application/json'}
		}

		@client.execute(options)
	end

	private

	def events_with_location(events)
		events_with_location = []
		events.each do |event|
			events_with_location << event if event.location
		end
		events_with_location
	end
end
