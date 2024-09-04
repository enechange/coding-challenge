# frozen_string_literal: true

class PeriodValidator < ActiveModel::Validator
  def validate(record)
    if record.to.blank?
      record.errors.add(:base, '同一プランで重複した値が登録されています') if end_infinite?(record)
    elsif [record.to, record.from].compact.max == record.from
      record.errors.add(:base, '終了値が、開始値よりも小さくなっています')
    elsif ElectricityUsage.exists?(from: ..record.from, to: record.to..,
                                   plan_id: record.plan_id)
      record.errors.add(:base, '同一プランで重複した値が登録されています')
    end
  end

  def end_infinite?(record)
    ElectricityUsage.where(from: ..record.from, to: record.from.., plan_id: record.plan_id)
                    .or(ElectricityUsage.where(
                          from: record.from.., to: nil, plan_id: record.plan_id
                        )).present?
  end
end
