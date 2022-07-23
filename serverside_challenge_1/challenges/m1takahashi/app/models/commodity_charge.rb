#
# 従量料金モデル
#
class CommodityCharge < ActiveYamlBase
  set_filename "commodity_charge"
  
  # 区分判別
  scope :classification, -> (kwh) {
    #where(max: kwh)
    where('max < ?', kwh)
  }  
end
