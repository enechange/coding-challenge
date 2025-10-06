# app/models/energy_plan.rb
class EnergyPlan
  attr_reader :provider_name, :plan_name, :basic_fee, :unit_fee

  # 初期化
  def initialize(provider_name, plan_name, basic_fee, unit_fee)
    @provider_name = provider_name
    @plan_name = plan_name
    # basic_fee は {アンペア数 => 金額} 形式
    @basic_fee = basic_fee.transform_keys(&:to_i)
    # unit_fee は {"0-120" => 19.88} 形式（上限0なら無制限）
    @unit_fee = unit_fee
  end

  #設定ファイルからプランを読み込み
  def self.load_plans
    plans_yaml = YAML.load_file(Rails.root.join('config/api_settings.yml'))[Rails.env]
    plans_yaml.map do |h|
      EnergyPlan.new(h['provider_name'], h['plan_name'], h['basic_fee'], h['unit_fee'])
    end
  end

  #契約アンペアと使用量から料金計算
  def calculate_fee(ampere, usage_kwh)
	
	#使用量チェック
    if usage_kwh <= 0 || usage_kwh >= MAX_USAGE_KWH
      return { error: true, message: "使用量が異常値です" }
    end

  	# 基本料金を取得（対象外なら -1）
    fee = basic_fee[ampere.to_i]
    #アンペアチェック
    unless fee
      return { error: true, message: "対応する基本料金が見つかりません" }
    end
    
    usage_fee = 0.0
	
	#使用量に応じて従量料金を加算
    #"0-120"、"121-300"、"301-0"で250kwの場合
    #"0-120"：min = 0, max = 120、[250, 120].min = 120、120 - 0 = 120
    #"121-300"：min = 121, max = 300[250, 300].min = 250、250 - 121 = 129
    #"301-0"：スキップ
    unit_fee.each do |range, price|
      min, max = range.split('-').map(&:to_f)	#"0-120"を-で分解して数値化
      max = Float::INFINITY if max.zero? #上限が0の場合は無制限

      if usage_kwh > min
      	# 区間内での使用量を計算
        kwh = [usage_kwh, max].min - min
        usage_fee += kwh * price
      end
    end
	
	# 基本料金 + 従量料金 を小数点2桁で丸めて返す
    (fee + usage_fee).round(2)
    
  rescue => e
  	# 計算中に例外が起きた場合はログ出力して -1 を返す
    Rails.logger.error("Error calculating fee: #{e.message}")
    #例外発生時のエラー
    { error: true, message: "料金計算中にエラーが発生しました" }
  end
end