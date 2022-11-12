module Suggest
  def suggest_calc(amp, kwh)
    # ①amperage関連の必要情報の抽出
    amperage_info = Provider.joins(plans: :amperages).where(amperages: {amperage: amp}).pluck("plans.id, amperage_price, providers.name, plans.name")

    # ②amperage_infoから該当AのPlanの抽出 
    amperage_plan = amperage_info.map{|i| i[0]}

    # ③amperage_infoから該当Aのamperage_priceの抽出
    amperage_price = amperage_info.map{|i| i[1]}

    # ④該当Planの全kilowatto抽出
    kilowattos = Provider.joins(plans: :kilowattos).where(plans: {id: amperage_plan}).pluck("min_kilowatto, max_kilowatto, kilowatto_price")

    # ⑤取得した④のkilowattoから該当のkilowatto_priceを抽出
    kilowatto_price = []
    kilowatto_price << 0 if kwh == '0'
    kwh = kwh.to_i
    kilowattos.each do |i|
      if (i[0] < kwh) && ((i[1] ||= 0) >= kwh)
        kilowatto_price << i[2]
      elsif (i[0] < kwh) && (i[1] == 0)
        kilowatto_price << i[2]
      end
    end

    # ⑥ ③と⑤から、合計値を計算しcalc_priceに入れる
    calc_price = []
    amperage_price.zip(kilowatto_price) do |a, k|
      calc_price << (a + ((k||=0) * kwh)).round
    end

    # ⑦amperage_infoからProvider名,Plan名の取得
    providers_plans_name = amperage_info.map{|i| [i[2], i[3]]}


    # ⑧ ⑥と⑦から、Provider名,Plan名,calc_priceの配列を生成
    providers_plans_prices = []
    providers_plans_name.zip(calc_price) do |p_name,c_price|
      providers_plans_prices << (p_name << c_price)
    end

    # ⑨指定されたレスポンス形式に成形 or A,kWhが指定の値ではない場合エラーメッセージを出す
    if amperage_info.present? && kilowatto_price.present?
      providers_plans_prices.map{|i|{provider_name: i[0], plan_name: i[1], price: i[2]}}
    elsif amperage_info.blank?
      { Error: 'Aを指定の値にしてください。' }
    else
      { Error: 'kWhを指定の値にしてください。' }
    end
  end
end