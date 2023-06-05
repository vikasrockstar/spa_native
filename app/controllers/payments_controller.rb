class PaymentsController < ActionController::Base
  layout 'custom_layout'
  def index
    @user = User.find_by(id: params[:user_id])
    render 'index'
  end
end