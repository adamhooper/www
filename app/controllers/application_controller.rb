class ApplicationController < ActionController::Base
  include SimpleCaptcha::ControllerHelpers

  helper :all
  layout 'common'

  protect_from_forgery
  filter_parameter_logging :password

  helper_method :admin?
  def admin?
    session[:admin] == true
  end

  private

  def authorize
    unless admin?
      flash[:error] = 'Unauthorized access'
      redirect_to(root_url)
    end
  end
end
