class SessionsController < ApplicationController
	def create
		user = User.from_omniauth(env["omniauth.auth"])
		session[:user_id] = user.id

		user_calendar = GoogleCalendar.new(current_user)
		puts "STARTING"
		puts user_calendar.calendar_watch

		redirect_to root_path
	end

	def destroy
		session[:user_id] = nil
		redirect_to root_path
	end
end