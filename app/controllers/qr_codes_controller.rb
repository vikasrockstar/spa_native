class QrCodesController < ApplicationController
  before_action :authorize_request, only: [:create, :list]

  def create
    # Generate payment link from stripe api for given amount
    payment_link = StripePayment.new(@current_user, params[:amount]).create_payment_link
    qr_code = @current_user.qr_codes.new(qr_code_params.merge!(url: payment_link))
    if qr_code.save
      # generate qr code image and attach to qr code
      blob = QrCodeGenerator.generate(payment_link)
      qr_code.image.attach(blob)
      render json: qr_code.filter_attributes.merge!(image_url: qr_code.image&.url), status: 201
    else
      render json: { errors: qr_code.errors.full_messages }, status: 422
    end
  rescue
    render json: { errors: 'Can not process at the moment' }, status: 422
  end

  def list
    qr_codes = @current_user.qr_codes
    qr_code_data = []
    qr_codes.each do |qr_code|
      qr_code_data << qr_code.filter_attributes.merge!(image_url: qr_code.image&.url)
    end
    render json: {list: qr_code_data}, status: 200
  end
  
  private

  def qr_code_params
    params.permit(:amount)
  end
end
