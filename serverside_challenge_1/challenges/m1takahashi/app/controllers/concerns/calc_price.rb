module CalcPrice
  extend ActiveSupport::Concern
  
  # 使用量から,区分に合わせた料金単価を取得
  # DBを使用する場合には,where('min >= ?', amount).where('max <= ?', amount)で取得できるので,このメソッドは不要
  def commodity_unit_price(commodity_charges, amount)
    commodity_charges.each do |commodity_charge|
      if (commodity_charge.min <= amount && commodity_charge.max >= amount)
        return commodity_charge.charge_with_tax
      end
    end
    return 0
  end
end
