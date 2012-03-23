class ApplicationController < ActionController::Base
  helper :all

  protect_from_forgery

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
