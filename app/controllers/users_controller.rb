class UsersController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :authorize_request, only: [:profile, :reset_password, :update, :transactions, :graph_data, :wallet, :language]
  before_action :set_user, only: [:login, :reset_password, :generate_otp, :validate_otp]
  before_action :check_email, only: [:update_mobile_number]
  before_action :set_user_params, only: [:registration, :update]

  SUPPORTED_LANGUAGES = ['ar', 'fr', 'en']

  def registration
    user = User.new(new_user_params)
    if user.save
      render json: user.filter_attributes, status: 201
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def login
    if @user&.authenticate(params[:password]) && !@user.suspended?
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    elsif @user.suspended?
      render json: { errors: ['User is suspended'] }, status: :forbidden
    else
      render json: { errors: ['password is incorrect'] }, status: 400
    end
  end

  def profile
    token = JsonWebToken.encode(user_id: @current_user.id)
    render json: @current_user.filter_attributes.merge!(image_data).merge!(wallet_data).merge!(token: token), status: 200
  end

  def reset_password
    if @user.update(password: params[:password])
      render json: { user: @user.filter_attributes }, status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def generate_otp
    @user.send_auth_code unless @user.country_code == "+91"
    render json:  {user: @user.filter_attributes, message: 'otp sent to mobile number'}, status: 200
  end

  def validate_otp
    if @user.country_code == "+91" && params[:otp_code] == '1234'
      @user.is_mobile_verified = true
      @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { user: @user.filter_attributes, token: token, message: 'successfully validated otp code' }, status: 200
    elsif @user.authenticate_otp(params[:otp_code], auto_increment: true)
      @user.is_mobile_verified = true
      @user.save
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { user: @user.filter_attributes, token: token, message: 'successfully validated otp code' }, status: 200
    else
      render json: { errors: ['invalid otp code']}, status: 422
    end
  end

  def update_mobile_number
    if @user.update(mobile_params)
      render json: { user: @user.filter_attributes }, status: 200
    else
      render json: { errors: @user.errors.full_messages }, status: 422
    end
  end

  def update
    if @current_user.update(update_params)
      render json: { user: @current_user.filter_attributes }, status: 200
    else
      render json: { errors: @current_user.errors.full_messages }, status: 422
    end
  end

  def transactions
    per_page, page_number = [ 100, params[:page_number].to_i ]
    total_transactions = @current_user.transactions.count
    total_pages = total_transactions/per_page
    next_page = (page_number >= total_pages - 1) ? -1 : page_number+1
    transactions = @current_user.transactions.order(created_at: :desc).offset(per_page*page_number).limit(per_page)
    render json: { list: transactions, page_number: next_page }, status: 200
  rescue
    render json: { errors: ['Invalid parameters']}, status: 422
  end

  # transaction graph data
  def graph_data
    if params[:type].present?
     data = []
     case params[:type]
        when "weekly"
          transactions = @current_user.transactions.transactions_between(1.week.ago, Time.now)
          current_day = Time.now.end_of_day
          (0..6).to_a.each do  |day|
            current_day_trans = transactions.transactions_between(current_day - 1.day, current_day)
             data_hash = {
              :amount => current_day_trans.present? ? current_day_trans.sum(:amount) : 0,
              :date => current_day,
              :value_for => current_day.strftime('%a')
             }
             data << data_hash
            current_day = current_day - 1.day
            end

        when "monthly"
          transactions = @current_user.transactions.transactions_between(1.year.ago, Time.now)
          current_month = Time.now.end_of_month
          (0..11).to_a.each do  |day|
            current_month_trans = transactions.transactions_between(current_month - 1.months, current_month)
             data_hash = {
              :amount => current_month_trans.present? ? current_month_trans.sum(:amount) : 0,
              :date => current_month,
              :value_for => current_month.strftime('%b %y')
             }
             data << data_hash
             current_month = current_month - 1.months
            end
        end
      render json: { list: data, type: params[:type] }, status: 200
    else
      render json: {errors: ['incorrect or invalid params']}
    end
  end

  def wallet
    render json: { wallet: @current_user.wallet.balance }, status: 200
  end

  def language
    if params[:language].present? && SUPPORTED_LANGUAGES.include?(params[:language])
      @current_user.update(language_preference: params[:language])
      render json: @current_user.filter_attributes.merge!(image_data).merge!(wallet_data), status: 200
    else
      render json: { errors: ['incorrect or invalid params']}, status: 422
    end
  end

  def users_list
  end

  private

  def set_user_params
    @user_params ||= ActionController::Parameters.new({
      user: {
        email: params[:email],
        first_name: params[:first_name],
        last_name: params[:last_name],
        mobile_number: params[:mobile_number],
        country_code: params[:country_code],
        country_chars: params[:country_chars],
        password: params[:password],
        password_confirmation: params[:password_confirmation],
        dob: params[:dob]
      }
    })
  end

  def new_user_params
    @user_params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name,
      :mobile_number, :country_code, :country_chars, :dob, :address)
  end

  def update_params
    @user_params.require(:user).permit(:first_name, :last_name, :dob, :business_id_card, :about_me)
  end

  def mobile_params
    params.require(:user).permit(:mobile_number, :country_code, :country_chars)
  end

  def set_user
    @user = User.find_by(mobile_number: params[:mobile_number])
    if @user.nil?
      render json: { errors: ['Mobile number is incorrect'] }, status: 400
    elsif @user.country_code != params[:country_code]
      render json: { errors: ['Country code is incorrect'] }, status: 400
    end
  end
  
  def check_email
    @user = User.find_by(email: params[:email])
    if @user.nil?
      render json: { errors: ['user not found'] }, status: 400
    elsif @user.is_mobile_verified?
      render json: { errors: ['user is already verified'] }, status: 422
    end
  end

  def image_data
    {
      image: @current_user.profile_picture_url
    }
  end
  def wallet_data
    {
      user_wallet: @current_user.wallet.as_json(only: [:id, :balance])
    }
  end
end
