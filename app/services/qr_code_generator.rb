class QrCodeGenerator 
  require "rqrcode"

  def self.generate(payment_link)
    generate_qr_code_png = RQRCode::QRCode.new(payment_link).as_png
    image_path = "tmp/image.png"
    IO.binwrite(image_path, generate_qr_code_png.to_s)
    ActiveStorage::Blob.create_and_upload!(io: File.open(image_path),filename: 'image.png')
  end
end
