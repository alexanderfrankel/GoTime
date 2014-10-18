class HomeController < ApplicationController
	def index
		if current_user
		  client = Google::APIClient.new
		  client.authorization.access_token = current_user.oauth_token
		  service = client.discovered_api('calendar', 'v3')
		  options = {
		    :api_method => service.calendar_list.list,
		    :parameters => {},
		    :headers    => {"Content-Type" => "application/json"}
		  }
		  @result = client.execute(options)
		end
	end
end