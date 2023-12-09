# frozen_string_literal: true

class Validator
  include Constants

  attr_reader :error_message

  def initialize(ampere, usage)
    @ampere = ampere
    @usage = usage
    @error_message = nil
  end

  def validate
    unless validate_ampere
      @error_message = "契約アンペア数は#{VALID_AMPERES.join(',')}のいずれかでなければなりません。"
      return false
    end

    unless validate_usage
      @error_message = '使用量は0以上の整数でなければなりません。'
      return false
    end
    true
  end

  private

  def validate_ampere
    VALID_AMPERES.include?(@ampere)
  end

  def validate_usage
    @usage >= 0
  end
end
