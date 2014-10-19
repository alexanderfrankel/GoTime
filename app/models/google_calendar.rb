class GoogleCalendar

	def initialize(current_user)
		@current_user = current_user
		@client = Google::APIClient.new
		@client.authorization.access_token = @current_user.oauth_token
		@service = @client.discovered_api('calendar', 'v3')
	end

	def display_calendar_events
		options = {
		  :api_method => @service.events.list,
		  :parameters => {"calendarId" => @current_user.email},
		  :headers    => {"Content-Type" => "application/json"}
		}

		@client.execute(options).data.items
	end

	def calendar_watch
		options = {
			:api_method => @service.events.watch,
			:parameters => {"calendarId" => @current_user.email},
			:body => JSON.dump({id: "cbi4vk1XUqBEX2Y2oK35Og",
													type: "web_hook",
													address: "https://42672916.ngrok.com/google_notifications"}),
			:headers => {'Content-Type' => 'application/json'}
		}

		@client.execute(options)
	end

	# def add_transit_event
	# 	options = {
	# 		:api_method => service.events.insert,
	# 		:parameters => {'calendarId' => 'primary'},
	# 		:body => JSON.dump(event),
	# 		:headers => {'Content-Type' => 'application/json'}
	# 	}
	# end
end