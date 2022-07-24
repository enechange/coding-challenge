# 基本料金モデル
# belongs_to: provider
class BasicCharge < ActiveYamlBase
  set_filename "basic_charge"
  
  # 許可アンペア数
  AMPERES = [10,15,20,30,40,50,60]
end
