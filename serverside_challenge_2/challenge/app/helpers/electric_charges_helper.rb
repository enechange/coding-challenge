module ElectricChargesHelper
  VALID_CONTRACT_AMPERES = %w(10 15 20 30 40 50 60).freeze
  VALID_USAGE_REGEX = /\A\d+\z/.freeze

  # リクエストパラメータのバリデーション
  def validate_params(request_params)
    # パラメータが不足しているとき
    if request_params[:ampere].nil? || request_params[:usage].nil?
      return { error: I18n.t('errors.empty_parameter') }, :bad_request
    end

    # ampereは特定値である必要がある
    unless VALID_CONTRACT_AMPERES.include?(request_params[:ampere])
      return { error: I18n.t('errors.invalid_contract_ampere') }, :bad_request
    end

    # usageは0以上の整数である必要がある
    usage = request_params[:usage].to_i
    unless VALID_USAGE_REGEX.match?(request_params[:usage])
      return { error: I18n.t('errors.invalid_usage') }, :bad_request
    end
    if usage < 0
      return { error: I18n.t('errors.invalid_usage') }, :bad_request
    end

    nil
  end

  # yamlからパラメータ読み込み
  def import_price_from_yaml(ampere, usage)
    results = []
    electricity_charges_data = YAML.load_file("config/electricity_charges.yml")
    # 基本料金
    electricity_charges_data["basic_price"].each do |provider|
      provider["plans"].each do |plan|
        if plan["amperes"].has_key?(ampere)
          results << {
            "provider_name": provider["provider_name"],
            "plan_name": plan["plan"],
            "price": plan["amperes"][ampere]
          }
        end
      end
    end

    # ampereのパラメータに紐づくデータがない場合はその旨を返す
    if results.empty?
      results << { message: I18n.t('message.empty_result_by_ampere') }
      return results, 404
    end

    # 従量料金
    results.each do |result|
      provider_usage_price_data = electricity_charges_data["usage_price"].select{|provider| provider["provider_name"] == result[:provider_name]}
      provider_usage_price_data.each do |data|
        plans = data["plans"].select {|plan| plan["plan"] == result[:plan_name]}
        plans.each do |plan|
          thresholds = plan["thresholds"]
          keys = thresholds.keys.map(&:to_i).sort.reverse
          keys.each do |key|
            if usage >= key
              unit_price_kwh = thresholds[key]
              usage_price = (unit_price_kwh * usage).round(2)
              result[:price] += usage_price
              break
            end
          end
        end
      end
    end

    [results, 200]
  end
end
