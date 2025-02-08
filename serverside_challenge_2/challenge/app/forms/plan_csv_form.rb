# frozen_string_literal: true

require 'csv'

class PlanCsvForm
  include ActiveModel::Model

  attr_accessor :basic_fee_file, :usage_fee_file

  def save
    return false unless valid?

    ActiveRecord::Base.transaction do
      save_basic_fees
      save_usage_fees
    end

    true
  # FIXME: StandardErrorではなく、具体的な例外を指定する
  rescue StandardError => e
    errors.add(:base, e.message)
    false
  end

  private

  def save_basic_fees
    basic_fees_data = CSV.read(basic_fee_file.path, headers: true)
    # プランごとの料金一覧を特定するため、provider_nameとplan_nameでグループ化
    basic_fees_data.group_by do |row|
      [row['provider_name'], row['plan_name']]
    end.each do |(provider_name, plan_name), rows|
      provider = ElectricityProvider.find_or_create_by!(name: provider_name)
      plan = provider.electricity_plans.find_or_create_by!(name: plan_name)
      # 既存の料金情報は全て削除して新しい情報を登録
      plan.electricity_plan_basic_fees.destroy_all
      rows.each do |row|
        plan.electricity_plan_basic_fees.create!(ampere: row['ampere'], fee: row['basic_fee'])
      end
    end
  end

  def save_usage_fees
    usage_fees_data = CSV.read(usage_fee_file.path, headers: true)
    usage_fees_data.group_by do |row|
      [row['provider_name'], row['plan_name']]
    end.each do |(provider_name, plan_name), rows|
      provider = ElectricityProvider.find_or_create_by!(name: provider_name)
      plan = provider.electricity_plans.find_or_create_by!(name: plan_name)
      plan.electricity_plan_usage_fees.destroy_all
      rows.each do |row|
        plan.electricity_plan_usage_fees.create!(min_usage: row['min_usage'], fee: row['usage_fee'])
      end
    end
  end
end
