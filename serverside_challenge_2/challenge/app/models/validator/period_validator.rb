# frozen_string_literal: true

module Validator
  class PeriodValidator < ActiveModel::Validator
    def validate(record)
      if record.from.present? && [record.to, record.from].compact.max == record.from
        record.errors.add(:base, '終了値が、開始値よりも小さくなっています')
      elsif record.from.present? && ElectricityUsage.exists?(from: ..record.from, to: record.to..,
                                                             plan_id: record.plan_id)
        record.errors.add(:base, '同一プランで重複した値が登録されています')
      end
    end
  end
end
