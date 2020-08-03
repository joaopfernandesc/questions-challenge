# frozen_string_literal: true
class ApplicationController < ActionController::API
  include ChallengeExceptions
  rescue_from StandardError, with: :render_http_error

  def render_http_error(exception)
    if exception.is_a?(ChallengeExceptions::BadParameters)
      render(json: { error: "Parâmetros incorretos." }, status: 400)
    else
      Rails.logger.error(exception.message)
      Rails.logger.error(exception.backtrace.join("\n"))
      render(json: { error: "Erro interno do servidor." }, status: 500)
    end
  end
end
