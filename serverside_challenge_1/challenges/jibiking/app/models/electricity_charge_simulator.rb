class ElectricityChargeSimulator
  def calc(amp, kwh)
    # ampが含まれるplanのidの取得
    amperage_plan = Plan.joins(:amperages).where(amperages: {amperage: amp}).select(:id)

    # 上記planの全kilowattoを取得
    kilowattos = Kilowatto.joins(:plan).where(plans: {id: amperage_plan}).select(:min_kilowatto, :max_kilowatto, :kilowatto_price)

    # 取得した全kilowattoから、与えられたkwhに該当する範囲の従量料金を取得
    kilowatto_prices = []
    kilowattos.each do |kilowatto|
      # kilowattoの中身を変数に格納
      min_kilowatto = kilowatto[:min_kilowatto]
      max_kilowatto = kilowatto[:max_kilowatto]||= 0  # nilの場合0を代入
      kilowatto_price = kilowatto[:kilowatto_price]

      # 与えられたkwhに該当するkilowatto範囲を判定し、該当するkilowatto_priceの従量料金を取得
      kilowatto_prices << kilowatto_price * kwh if ((min_kilowatto == 0) && (max_kilowatto >= kwh)) || ((min_kilowatto < kwh) && (max_kilowatto >= kwh)) || ((min_kilowatto < kwh) && (max_kilowatto == 0))
    end

    # 与えられたampの基本料金を取得
    amperage_prices = Amperage.where(amperage: amp).pluck(:amperage_price)

    # 取得した基本料金と従量料金から電気料金の計算（小数点以下切り捨て）
    prices = []
    amperage_prices.zip(kilowatto_prices) do |amperage_price, kilowatto_price|
      prices << (amperage_price + kilowatto_price).floor
    end

    # レスポンスに必要な電力会社名とプラン名の取得
    provider_names = Provider.joins(plans: :amperages).where(amperages: {amperage: amp}).pluck(:name)
    plan_names = Plan.joins(:amperages).where(amperages: {amperage: amp}).pluck(:name)

    # 電力会社名・プラン名・電気料金をハッシュに格納
    response = []
    provider_names.zip(plan_names, prices) do |provider_name, plan_name, price|
      response.push({
        provider_name: provider_name,
        plan_name: plan_name,
        price: price
      })
    end
    
    response
  end
end