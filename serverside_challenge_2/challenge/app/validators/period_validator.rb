# frozen_string_literal: true

class PeriodValidator < ActiveModel::Validator
  def validate(record)
    if record.to.blank?
      # 終端値が未設定の場合
      if ElectricityUsage.exists?(from: record.from.., plan_id: record.plan_id) ||
        ElectricityUsage.exists?(to: record.from.., plan_id: record.plan_id)
        record.errors.add(:base, '同一プランで重複した値が登録されています')
      end
    elsif [record.to, record.from].compact.max == record.from
      record.errors.add(:base, '終了値が、開始値よりも小さくなっています')
    elsif ElectricityUsage.exists?(from: ..record.from, to: record.to..,
                                   plan_id: record.plan_id)
      record.errors.add(:base, '同一プランで重複した値が登録されています')
    end
  end
end
