class HomeController < ApplicationController
	def index
		if current_user
			@current_user = current_user
		  user_calendar = GoogleCalendar.new(current_user)
		  puts
		  puts "THIS IS IT:"
		  user_calendar.calendar_watch
		  puts "THIS IS THE END ----------"

		  @result = user_calendar.display_calendar_events
		end
	end
end