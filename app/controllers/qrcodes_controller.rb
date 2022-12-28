class QrcodesController < ApplicationController
  include Rails.application.routes.url_helpers

  def create
    qrcode = Qrcode.new(qrcode_params)
    if qrcode.save
      QrcodeGenerator.new(qrcode).qrcode_generator
      image = rails_blob_url(qrcode.qrcode_image, only_path: false) if qrcode.qrcode_image.attached?
      response = {qr_code_url: image,image: qrcode.image,amount: qrcode.amount,qrcode_id: qrcode.id,user_id: qrcode.user_id}
      render json: response, status: 201
    else
      render json: { errors: qrcode.errors.full_messages }, status: 422
    end
  end

  def show
    user = User.find (params[:user_id])
    qrcodes = user.qrcodes
    images = []
    qrcodes.each do |qrcode|
      image = rails_blob_url(qrcode.qrcode_image, only_path: false) if qrcode.qrcode_image.attached?
      images << {qr_code_url: image, qr_details: qrcode} if image.present?
    end
    render json: {qrcode: images}, status: 201
  end

  def update
    @qrcode = Qrcode.find(params[:qrcode_id])
    if @qrcode.update(qrcode_params)
      message = "qrcode sucessfully updated"
    else
      message = "qrcode not updated"
    end
    render json: {message: message}, status: 201
  end

  def destroy
    qrcode = Qrcode.find(params[:qrcode_id])
    if qrcode.destroy
      message = "sucessfully deleted"
    else 
      message = "qrcode not found"
    end
    render json: {message: message}, status: 201
  end
  
  private

  def qrcode_params
    params.permit(:url,:image,:amount,:user_id)
  end
end
