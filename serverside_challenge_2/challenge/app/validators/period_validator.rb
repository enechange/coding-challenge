# frozen_string_literal: true

class PeriodValidator < ActiveModel::Validator
  def validate(record)
    if record.from.present? && [record.to, record.from].compact.max == record.from
      record.errors.add(:to, :cannot_assign_short_value_to_from)
    elsif record.from.present? && ElectricityUsage.exists?(from: ..record.from, to: record.to..,
                                                           plan_id: record.plan_id)
      record.errors.add(:base, :not_unique)
    end
  end
end
