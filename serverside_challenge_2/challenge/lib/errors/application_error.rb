# frozen_string_literal: true

module ApplicationError
  class BaseError < StandardError
    attr_reader :message

    def initialize(message)
      @message = message
      super
    end
  end

  class BadRequestError < BaseError
  end
end
