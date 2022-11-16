module ElectricityChargeSimulatorsCalc
  def electricity_charge_simulators_calc(amp, kwh)
    # ①amperage関連の必要情報の抽出


    # ②該当AのPlan.idの抽出 
    amperage_plan = Plan.joins(:amperages).where(amperages: {amperage: amp}).pluck(:id)

    # ③該当Aのamperage_priceの抽出
    amperage_prices = Amperage.where(amperage: amp).pluck(:amperage_price)

    # ④該当Planの全kilowatto抽出
    kilowattos = Kilowatto.joins(:plan).where(plans: {id: amperage_plan}).pluck("min_kilowatto, max_kilowatto, kilowatto_price")

    # ⑤取得した④のkilowattoから該当のkilowatto_priceを抽出
    kilowatto_prices = []
    kilowatto_prices << 0 if kwh == '0'
    kwh = kwh.to_i
    kilowattos.each do |kilowatto|
      if (kilowatto[0] < kwh) && ((kilowatto[1] ||= 0) >= kwh)
        kilowatto_prices << kilowatto[2]
      elsif (kilowatto[0] < kwh) && (kilowatto[1] == 0)
        kilowatto_prices << kilowatto[2]
      end
    end

    # ⑥ ③と⑤から、合計値を計算しcalc_priceに入れる
    calc_price = []
    amperage_prices.zip(kilowatto_prices) do |amperage_price, kilowatto_price|
      calc_price << (amperage_price + ((kilowatto_price||=0) * kwh)).round
    end

    # ⑦amperage_infoからProvider名,Plan名の取得
    providers_plans_name = Provider.joins(:plans).pluck("providers.name, plans.name")


    # ⑧ ⑥と⑦から、Provider名,Plan名,calc_priceの配列を生成
    providers_plans_prices = []
    providers_plans_name.zip(calc_price) do |p_name,c_price|
      providers_plans_prices << (p_name << c_price)
    end

    # ⑨指定されたレスポンス形式に成形 or A,kWhが指定の値ではない場合エラーメッセージを出す
    if amperage_plan.present? && kilowatto_prices.present?
      providers_plans_prices.map{|i|{provider_name: i[0], plan_name: i[1], price: i[2]}}
    elsif amperage_plan.blank?
      { Error: 'Aを指定の値にしてください。' }
    else
      { Error: 'kWhを指定の値にしてください。' }
    end
  end
end