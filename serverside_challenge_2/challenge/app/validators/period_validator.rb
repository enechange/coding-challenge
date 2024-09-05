# frozen_string_literal: true

class PeriodValidator < ActiveModel::Validator
  def validate(record)
    if record.to.blank?
      record.errors.add(:base, :not_unique) if end_infinite?(record)
    elsif [record.to, record.from].compact.max == record.from
      record.errors.add(:to, :cannot_assign_short_value_to_from)
    elsif ElectricityUsage.exists?(from: ..record.from, to: record.to..,
                                   plan_id: record.plan_id)
      record.errors.add(:base, :not_unique)
    end
  end

  def end_infinite?(record)
    ElectricityUsage.where(from: ..record.from, to: record.from.., plan_id: record.plan_id)
                    .or(ElectricityUsage.where(
                          from: record.from.., to: nil, plan_id: record.plan_id
                        )).present?
  end
end
