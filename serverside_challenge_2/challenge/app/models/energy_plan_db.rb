# app/models/energy_plan_db.rb
class EnergyPlanDb < ApplicationRecord
  # energy_plans テーブルと対応
  self.table_name = 'energy_plans'

  # 関連テーブルの設定
  has_many :basic_fees, foreign_key: :energy_plan_id
  has_many :unit_fees, foreign_key: :energy_plan_id

  # 利用可能なプランのみ取得
  def self.load_plans
    includes(:basic_fees, :unit_fees) # N+1対策で関連テーブルをまとめて取得
      .where(active: true)             # activeフラグがtrueのプランのみ
  rescue => e
    Rails.logger.error("Error loading plans via DB: #{e.message}")
    []  # エラー時は空配列
  end

  # 契約アンペアと使用量から料金計算
  def calculate_fee(ampere, usage_kwh)
	#使用量チェック
    if usage_kwh <= 0 || usage_kwh >= MAX_USAGE_KWH
      return { error: true, message: "使用量が異常値です" }
    end
	# 契約アンペアに対応する基本料金を取得
    fee_record = basic_fees.find { |bf| bf.ampere == ampere.to_i }
	#アンペアチェック
    unless fee_record
      return { error: true, message: "対応する基本料金が見つかりません" }
    end

    # 見つかった基本料金の金額を取得（float に変換）
    fee = fee_record.price.to_f

    # 従量料金を加算
    usage_fee = 0.0
    # unit_fees テーブルに登録されている各従量料金設定を処理
    unit_fees.each do |uf|
      # この従量料金が適用される最小使用量 (kWh)
      min = uf.min_kwh.to_f
      # 最大使用量が未設定(nil) または 0 の場合は「上限なし」として扱う
      max = uf.max_kwh.nil? || uf.max_kwh.zero? ? Float::INFINITY : uf.max_kwh.to_f
      
      # 実際の使用量が min を超えている場合にのみ、この従量料金が適用される
      if usage_kwh > min
        # この従量料金帯に該当する使用量（min を超えて max までの範囲）
        kwh = [usage_kwh, max].min - min
        # 該当する使用量 × 単価を従量料金に加算
        usage_fee += kwh * uf.price.to_f
      end
    end
    
	# 合計料金を計算（基本料金 + 従量料金）、小数点以下2桁に四捨五入
    (fee + usage_fee).round(2)
  rescue => e
    Rails.logger.error("Error calculating fee: #{e.message}")
    #例外発生時のエラー
    { error: true, message: "料金計算中にエラーが発生しました" }
  end
end