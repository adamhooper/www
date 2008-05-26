# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers

  helper :all # include all helpers, all the time
  layout 'common'

  protect_from_forgery # :secret => 'efd73714528b27cc4a921d013e83c5e0'
  filter_parameter_logging :password

  helper_method :admin?
  def admin?
    session[:admin] == true
  end

  private

  def authorize
    unless admin?
      flash[:error] = 'Unauthorized access'
      redirect_to root_path
    end
  end
end
