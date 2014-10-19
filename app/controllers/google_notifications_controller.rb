class GoogleNotificationsController < ApplicationController
	skip_before_action :verify_authenticity_token

	def create
		puts response
		request_header = { "Channel-ID" => request.headers["X-Goog-Channel-ID"],
											 "Message-Number" => request.headers["X-Goog-Message-Number"],
											 "Resource-ID" => request.headers["X-Goog-Resource-ID"],
											 "Resource-State" => request.headers["X-Goog-Resource-State"],
											 "Resource-URI" => request.headers["X-Goog-Resource-URI"] }
		puts "REQUEST HEADER"
		puts request_header

		# current_user_calendar = GoogleCalendar.new(current_user)

		render :nothing => true
	end
end