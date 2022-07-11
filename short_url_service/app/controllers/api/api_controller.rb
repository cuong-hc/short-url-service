class Api::ApiController < ApplicationController
  include Api::ErrorFormatter
  skip_before_action :verify_authenticity_token

  rescue_from *[
    ActionController::ParameterMissing,
  ], :with => :render_error_response

  def render_error_response(error)
    error_type = error.class.name
    title = I18n.t("error_messages.#{error_type}.title") || error.message
    app_code = I18n.t("error_messages.#{error_type}.app_code")
    status_code = I18n.t("error_messages.#{error_type}.http_code") || 400
    render json: error_format(title, app_code, error.message), status: status_code
  end  
end
