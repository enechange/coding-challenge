#
# 電力会社モデル
#
# id: PK
# provider_name: 電力会社名
# plan_name: プラン名
#
# ActiveYamlは,Associationsを持っていない.
# 将来的にDB管理する場合は,has_manyで簡略化できる.
# has_many: basic_charges
# has_many: commodity_charges
#
class Provider < ActiveYamlBase
  set_filename "provider"
end
