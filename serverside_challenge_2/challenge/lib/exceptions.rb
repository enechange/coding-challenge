# frozen_string_literal: true

module App
  class Error < StandardError; end
  class InvalidParameterError < Error; end
  class DataNotFound < Error; end
end
