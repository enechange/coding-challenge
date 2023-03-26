class ErrorController < ApplicationController
  Rails.logger.level = :info
  def not_found
    render status: 404, json: ["Not Found"]
  end
end
