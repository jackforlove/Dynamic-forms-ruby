Rails.application.config.middleware.use OmniAuth::Builder do
  provider :josh_id, Setting.app_id, Setting.app_secret
end