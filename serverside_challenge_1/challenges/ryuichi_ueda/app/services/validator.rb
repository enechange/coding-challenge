# frozen_string_literal: true

class Validator
  include ActiveModel::Validations
  include Constants

  attr_accessor :ampere, :usage

  validate :validate_ampere
  validate :validate_usage

  def initialize(ampere, usage)
    @ampere = ampere
    @usage = usage
  end

  private

  def validate_ampere
    return if VALID_AMPERES.include?(@ampere)

    errors.add(:ampere, "は#{VALID_AMPERES.join(',')}のいずれかでなければなりません。")
  end

  def validate_usage
    return if @usage >= 0

    errors.add(:usage, 'は0以上の整数でなければなりません。')
  end
end
