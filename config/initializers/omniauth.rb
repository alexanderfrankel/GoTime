OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, Rails.application.secrets.google_client_id, Rails.application.secrets.google_secret_id, {
    access_type: 'offline',
    scope: 'https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/calendar'
  }
end
