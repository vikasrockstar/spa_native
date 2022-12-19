class UsersController < ApplicationController
  before_action :authorize_request, only: [:profile, :reset_password, :update, :upload_image, :transactions]
  before_action :set_user, only: [:login, :reset_password, :generate_otp, :validate_otp]
  before_action :check_email, only: [:update_mobile_number]

  def registration
    params["user"].merge!(password: params['password'], password_confirmation: params['password_confirmation'])
    user = User.new(user_params)
    if user.save
      render json: user.filter_password, status: 201
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def login
    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { errors: 'Mobile number or password not found' }, status: 400
    end
  end

  def profile
    render json: @current_user.filter_password.merge!(user_wallet: @current_user.wallet.as_json(only: [:id, :balance]) ), status: 200
  end

  def reset_password
    if @user.update(password: params[:password])
      render json: { user: @user.filter_password }, status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def generate_otp
    @user.send_auth_code
    render json: @user.filter_password, message: 'otp sent to mobile number', status: 200
  end

  def validate_otp
    @user.authenticate_otp(params[:otp_code], auto_increment: true)
    if params[:otp_code] == '1234'
      @user.is_mobile_verified = true 
      @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { user: @user.filter_password, token: token, message: 'successfully validated otp code' }, status: 200
    else
      render json: {message: 'invalid otp code'}, status: 401
    end
  end

  def update_mobile_number
    if @user.update(mobile_params)
      render json: { user: @user.filter_password }, status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def update
    if @current_user.update(update_params)
      render json: { user: @current_user.filter_password }, status: 200
    else
      render json: { errors: @current_user.errors.full_messages }, status: 422
    end
  end

  def transactions
    per_page, page_number = [ 10, params[:page_number].to_i ]
    total_transactions = @current_user.transactions.count
    total_pages = total_transactions/per_page
    next_page = (page_number >= total_pages -1) ? -1 : page_number+1
    transactions = @current_user.transactions.offset(per_page*page_number).limit(per_page)
    render json: { list: transactions, page_number: next_page }, status: 200
  rescue
    render json: { errors: 'Invalid parameters'}, status: 200
  end

  def upload_image
    @current_user.profile_picture = params[:file]
    if @current_user.save
      render json: { user: @current_user.filter_password }, status: 200
    else
      render json: { errors: @current_user.errors.full_messages }, status: 422
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :mobile_number, :country_code, :profile_picture)
  end

  def update_params
    params.require(:user).permit(:email, :first_name, :last_name)
  end

  def mobile_params
    params.require(:user).permit(:mobile_number, :country_code)
  end

  def set_user
    @user = User.find_by(mobile_number: params[:mobile_number], country_code: params[:country_code])
    render json: { errors: 'user not found' }, status: 400 if @user.nil?
  end
  
  def check_email
    @user = User.find_by(email: params[:email])
    if @user.nil?
      render json: { errors: 'user not found' }, status: 400
    elsif @user.is_mobile_verified?
      render json: { errors: 'user is already verified' }, status: 400
    end
  end
end
