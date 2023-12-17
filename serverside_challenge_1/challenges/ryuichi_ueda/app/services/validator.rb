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
    return if numeric?(@ampere) && VALID_AMPERES.include?(@ampere.to_i)

    errors.add(:ampere, "は#{VALID_AMPERES.join(',')}のいずれかの整数でなければなりません。")
  end

  def validate_usage
    return if numeric?(@usage) && @usage.to_i >= 0

    errors.add(:usage, 'は0以上の整数でなければなりません。')
  end

  def numeric?(string)
    string.match?(/\A\d+\z/)
  end
end
