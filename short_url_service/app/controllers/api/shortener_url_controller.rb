class Api::ShortenerUrlController < Api::ApiController
  def encode 
    encode_params = encode_url_params
    key_available = KeyAvailable.first
    if key_available
      short_url = ShortenerUrl.new(original_url: encode_params[:original_url], key_code: key_available.key_code, expired_at: DateTime.current)
      if short_url.save
        KeyUsed.create(key_code: key_available.key_code)
        key_available.destroy
        render json: {
          short_url: "http://short.est/#{short_url.key_code}"
        }, status: 201
      else
        render json: error_format(short_url.errors, 4000, short_url.errors.full_messages), status: 422
      end
    else
      render json: error_format(nil, 4001, "Sevice Unavailable"), status: 422
    end
  end

  def decode
    if params[:key_code].blank?
      render json: error_format(["Invalid key code"], 4003, "Invalid key code"), status: 422
      return
    end
    short_url = ShortenerUrl.find_by(key_code: params[:key_code].strip)
    if short_url
      render json: short_url.as_json(only:[:original_url]), status: 201
    else
      render json: error_format(["URL not found"], 4002, "URL not found"), status: 400
    end
  end  

  private
    def encode_url_params
      raise ActionController::ParameterMissing.new("original_url must not be blank") if params[:original_url].blank?
      params.permit(:original_url)
    end
end  