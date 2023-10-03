module Admin
  class UsersController < ActionController::Base
    # protect_from_forgery with: :null_session 
    before_action :set_user,  only: [:login]
  
    def login
      puts @user
      if @user && @user.authenticate(params[:password])
        redirect_to users_list_admin_users_path
      else
        render json: { errors: ['password is incorrect'] }, status: 400
      end
    end

    def users_list
      @users = User.all
    end

    private 

    def set_user
      return if params[:email] != 'admin@mytips.com' # will fetch from ENV

      @user = User.find_by(email: params[:email])
      if @user.nil?
        render json: {errors: ['Invalid email address']}, status: 400  
      end
    end
  end
end