class ApplicationController < ActionController::Base
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller
  include Hydra::Controller::ControllerBehavior
  include Hyrax::Controller
  include Hyrax::ThemedLayoutController
  with_themed_layout '1_column'


  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action do
    if defined?(Rack::MiniProfiler) && current_user && current_user.admin?
      Rack::MiniProfiler.authorize_request
    end
  end
end
