# frozen_string_literal: true

module Validator
  class PeriodValidator < ActiveModel::Validator
    def validate(record)
      if record.from.present? && [record.to, record.from].compact.max == record.to
        record.errors[:name] << '開始値が、終了値よりも小さくなっています'
      elsif record.from.present? && ElectricityUsage.exists?(from: record.from.., to: ..record.to,
                                                             plan_id: record.plan_id)
        record.errors[:name] << '同一プランで重複した値が登録されています'
      end
    end
  end
end
