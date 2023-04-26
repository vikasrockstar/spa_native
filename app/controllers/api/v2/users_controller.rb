class Api::V2::UsersController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :authorize_request, only: [:update]
  before_action :set_user_params, only: [:registration, :update]

  def registration
    user = User.new(new_user_params)
    user.profile_picture.attach(params[:image])
    if user.save
      render json: user.filter_attributes.merge!(image: user.profile_picture&.url), status: 201
    else
      render json: { errors: user.errors.full_messages }, status: 422
    end
  end

  def update
    @current_user.profile_picture.attach(params[:image]) if params[:image].present?
    if @current_user.update(update_params)
      render json: { user: @current_user.filter_attributes.merge!(image: @current_user.profile_picture&.url) }, status: 200
    else
      render json: { errors: @current_user.errors.full_messages }, status: 422
    end
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
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      }
    })
  end

  def new_user_params
    @user_params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :mobile_number, :country_code)
  end

  def update_params
    @user_params.require(:user).permit(:first_name, :last_name)
  end
end
