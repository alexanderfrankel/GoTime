class GoogleNotificationsController < ApplicationController
	skip_before_action :verify_authenticity_token

	def create
		user = User.where(channel_id: request.headers["X-Goog-Channel-ID"]).first

		event_builder = EventBuilder.new(user)
		event_builder.add_incremental_appts_and_transit_events_to_database

		render :nothing => true
	end
end