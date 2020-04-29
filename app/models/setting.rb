# RailsSettings Model
class Setting < RailsSettings::Base
  source "#{Rails.root}/config/application.yml"
  namespace Rails.env
end