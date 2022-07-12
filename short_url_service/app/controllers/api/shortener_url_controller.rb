class Api::ShortenerUrlController < Api::ApiController
  # =begin
  # @api {post} api/encode Encode URL
  # @apiName Encode URL
  # @apiGroup Encode URL
  # @apiDescription Encode URL
  # @apiParam {String} [original_url] URL for encoding
  # @apiParamExample {json} Request-Example:
  # {
  #   "original_url": "https://google.com"  
  # }
  # @apiSuccessExample {json} Success-Response:
  # HTTP/1.1 200 OK
  # {
  #   "short_url": "http://short.est/bYk7Q7"
  # }
  #@apiErrorExample {json} Error-Response:  
  # HTTP/1.1 422 Unprocessable Entity
  # {
  #   "error": {
  #       "errors": "Invalid parameters",
  #       "code": "invalid_parameters",
  #       "message": "param is missing or the value is empty: original_url must not be blank"
  #   }
  # }
  # =end
  def encode 
    encode_params = encode_url_params
    #In case, exist url no need encode
    url_exist = ShortenerUrl.find_by(original_url: encode_params[:original_url])
    if url_exist
      if DateTime.current > url_exist.expired_at
        render json: error_format("URL is expired", "expired_url", "URL is expired"), status: 422
      else
        render json: {
          short_url: "http://short.est/#{url_exist.key_code}"
        }, status: 201
      end
      return
    end

    #Encode URL
    key_available = KeyAvailable.first
    if key_available
      short_url = ShortenerUrl.new(original_url: encode_params[:original_url], 
                                   key_code: key_available.key_code, 
                                   expired_at: DateTime.current.next_year(1))
      if short_url.save
        KeyUsed.create(key_code: key_available.key_code, number_to_convert: key_available.number_to_convert)
        key_available.destroy
        render json: {
          short_url: "http://short.est/#{short_url.key_code}"
        }, status: 201
      else
        render json: error_format("Encode Failed", "encode_failed", short_url.errors.full_messages), status: 422
      end
    else
      render json: error_format("Sevice Unavailable", "service_unavailable", "Sevice Unavailable"), status: 422
    end
  end

  # =begin
  # @api {post} api/decode Decode URL
  # @apiName Decode URL
  # @apiGroup Decode URL
  # @apiDescription Decode URL
  # @apiParam {String} [key_code] key_code 
  # @apiParamExample {json} Request-Example:
  # {
  #     "key_code": "bYlukF"
  # }
  # @apiSuccessExample {json} Success-Response:
  # HTTP/1.1 200 OK
  # {
  #   "original_url": "https://google.com"
  # }
  #@apiErrorExample {json} Error-Response:  
  # HTTP/1.1 422 Unprocessable Entity
  # {
  #   "error": {
  #       "errors": "Invalid parameters",
  #       "code": "invalid_parameters",
  #       "message": "param is missing or the value is empty: key_code must not be blank"
  #   }
  # }
  # =end
  def decode
    decode_params = decode_url_params
    short_url = ShortenerUrl.find_by(key_code: decode_params[:key_code].strip)
    if short_url
      render json: short_url.as_json(only:[:original_url]), status: 201
    else
      render json: error_format("Decode URL not found", "decode_url_not_found", "Decode URL not found"), status: 400
    end
  end  

  private
    def encode_url_params
      raise ActionController::ParameterMissing.new("original_url must not be blank") if params[:original_url].blank?
      params.permit(:original_url)
    end

    def decode_url_params
      raise ActionController::ParameterMissing.new("key_code must not be blank") if params[:key_code].blank?
      params.permit(:key_code)
    end
end  