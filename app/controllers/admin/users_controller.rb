module Admin
  class UsersController < ActionController::Base
    layout 'custom_layout'
    protect_from_forgery with: :null_session
    ADMIN_EMAILS_LIST = ["admin@mytips.com"]

    before_action :require_login, only: [:users_list]
    before_action :set_user, only: [:login], if: -> { request.method == "POST" }
  
    def login
      if request.method == "POST"
        if @current_user && @current_user.authenticate(params[:password])
          session[:user_id] = @current_user.id
          redirect_to users_list_admin_users_path
        else
          # @error_message = "Password is invalid!"
          redirect_to login_admin_users_path
        end
      end
    end

    def users_list
      @users = User.all
    end

    private 

    def set_user
      @current_user = User.find_by(email: params[:email])

      unless ADMIN_EMAILS_LIST.include?(params[:email]) && @current_user.present?
        # flash[:alert] = "Email is invalid!"
        session[:user_id] = nil
        redirect_to login_admin_users_path
      end
    end

    def require_login
      redirect_to login_admin_users_path unless session.include? :user_id
    end
  end
end
