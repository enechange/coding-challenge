# 従量料金モデル
# belongs_to: provider
class CommodityCharge < ActiveYamlBase
  set_filename "commodity_charge"

  # 電力会社に紐ずく従量料金一覧を取得する
  # minとmaxの間にあるかをループで判別するため,minでソートしておく
  scope :provider, -> (provider_id) {
    where(provider_id: provider_id)
    .order(:min)
  }  
end
