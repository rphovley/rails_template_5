Apipie.configure do |config|
  config.app_name                = "RailsTemplate5"
  config.validate                = true
  config.api_base_url            = "/api"
  config.doc_base_url            = "/developer/docs"
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end
