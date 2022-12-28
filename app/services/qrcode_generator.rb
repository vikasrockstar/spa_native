class QrcodeGenerator 
    attr_reader :qrcode_image
    include Rails.application.routes.url_helpers
    require "rqrcode"

    def initialize(qrcode)
        @qrcode = qrcode
    end
   
    def qrcode_generator
      qr_url = url_for(controller: 'qrcodes', action:'create', id: @qrcode.user_id, only_path: false, host: @qrcode.url, source: 'from_qr')
      qr_url = qr_url.split('/qrcodes')[0]
      qrcode = RQRCode::QRCode.new(qr_url)
      image_name = SecureRandom.hex
      png = png_generator(qrcode)
      image_path = "tmp/#{image_name}.png"
      IO.binwrite(image_path, png.to_s)
      blob = ActiveStorage::Blob.create_and_upload!(
      io: File.open(image_path),
      filename: image_name
      )
      @qrcode.qrcode_image.attach(blob)
    end

    def png_generator(qrcode)
      png = qrcode.as_png(bit_depth: 1,border_modules: 4,color_mode: ChunkyPNG::COLOR_GRAYSCALE,color: "black",
      fill: "white",module_px_size: 6,resize_exactly_to: false,resize_gte_to: false,size: 120 )
      png
    end
end