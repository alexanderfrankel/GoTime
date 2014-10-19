class User < ActiveRecord::Base
	after_create :build_events

	has_many :events
	has_many :locations

	def self.from_omniauth(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
			user.email = auth.info.email
			user.provider = auth.provider
			user.uid = auth.uid
			user.oauth_token = auth.credentials.token
			user.oauth_expires_at = Time.at(auth.credentials.expires_at)
			user.save!
		end
	end

	def build_events
		event_builder = EventBuilder.new(self)
		event_builder.add_appts_and_transit_events_to_database
	end
end