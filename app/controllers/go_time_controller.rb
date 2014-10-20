class GoTimeController < ApplicationController
	def create
		if current_user
			current_user.location = Location.create(address: params["address"])

			current_user.update(:authorized? => true)
			current_user.save

			event_builder = EventBuilder.new(current_user)
			event_builder.add_initial_appts_and_transit_events_to_database
			event_builder.watch_user_calendar_for_event_changes
		end
		redirect_to root_path
	end

	def destroy
		if current_user
			current_user.update(:authorized? => false)
			current_user.save

			event_builder = EventBuilder.new(current_user)
			event_builder.disable_watch_user_calendar_for_event_changes
			event_builder.remove_all_user_events
		end
		redirect_to root_path
	end
end