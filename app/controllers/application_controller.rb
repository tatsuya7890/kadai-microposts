class ApplicationController < ActionController::Base
  
  #Helper のメソッドを使用するため
  include SessionsHelper
  
  private

  def require_user_logged_in
    unless logged_in?
      redirect_to login_url
    end
  end
end
