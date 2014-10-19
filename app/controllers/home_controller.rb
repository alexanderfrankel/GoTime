class HomeController < ApplicationController
	def index
		if current_user
		  user_calendar = GoogleCalendar.new(current_user)
		  @result = user_calendar.display_calendar_events
		end
	end
end