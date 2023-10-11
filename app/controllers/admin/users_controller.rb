module Admin
  class UsersController < ActionController::Base
    layout 'custom_layout'
    # protect_from_forgery with: :exception
    skip_before_action :verify_authenticity_token
    ADMIN_EMAILS_LIST = ["admin@mytips.com"]

    before_action :require_login, only: [:users_list]
    before_action :set_user, only: [:login], if: -> { request.method == "POST" }
    before_action :check_logged_in, only: [:login], if: -> { request.method == "GET" }
  
    def login
      if request.method == "POST"
        if @current_user && @current_user.authenticate(params[:password])
          session[:user_id] = @current_user.id
          redirect_to users_list_admin_users_path
        else
          flash[:error] = "Password is invalid!"
          redirect_to login_admin_users_path
        end
      end
    end

    def users_list
      @users = User.paginate(page: params[:page], per_page: 50)
    end

    def suspend
      user = User.find(params[:user_id])
      if user && !user.suspended
        user.update(suspended: true)
        render json: { success: true, message: 'User suspended successfully'}
      elsif user.suspended?
        render json: {success: false, message: 'User is already suspended'}
      else
        render json: {success: false, message: 'User not found'}
      end
    end

    private 

    def check_logged_in
      if session[:user_id].present?
        redirect_to users_list_admin_users_path
      end
    end

    def set_user
      @current_user = User.find_by(email: params[:email])

      unless ADMIN_EMAILS_LIST.include?(params[:email]) && @current_user.present?
        flash[:error] = "Email is invalid!"
        session[:user_id] = nil
        redirect_to login_admin_users_path
      end
    end

    def require_login
      redirect_to login_admin_users_path unless session.include? :user_id
    end
  end
end
