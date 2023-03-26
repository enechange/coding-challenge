# 電気料金計算サービス
#
# 電気料金を計算するためのロジックを提供するサービスクラス
class ElectricityRatesService
  # 初期化
  #
  # @param [Integer] ampere 契約アンペア数
  # @param [Integer] usage 電気使用量
  def initialize(ampere, usage)
    @ampere = ampere
    @usage = usage
  end

  # 電気料金を計算する
  #
  # @return [Array<Hash>] 各企業の電気料金を含む配列。入力データが無効の場合は空の配列を返す。
  def calculate_rates
    return [] unless valid_input?

    companies = Company.all
    companies.map { |company| calculate_company_rate(company) }.compact
  end

  private

  # 入力データの確認をする
  #
  # @return [Boolean] 入力データが有効な場合はtrue、無効な場合はfalse
  def valid_input?
    # 契約アンペア数のリスト
    valid_amperes = [10, 15, 20, 30, 40, 50, 60]

    # 以下の条件を満たす場合は正とする
    # 契約アンペア数がリストと一致する
    # 使用量が1以上999999以下の場合
    valid_amperes.include?(@ampere) && @usage.between?(1, 999999)
  end

  # 企業ごとの電気料金を計算する
  #
  # @param [Company] company 料金を計算する企業
  # @return [Hash, nil] 企業の電気料金情報。基本料金が存在しない場合はnilを返す。
  def calculate_company_rate(company)
    basic_fee = BasicCharge.where("company_id = ? AND (ampere = ? OR ampere = ?)", company[:id], @ampere, 999).pluck(:fee)

    return create_result(company[:provider_name], company[:plan_name], '') if basic_fee.blank?

    tiers = UsageCharge.where(company_id: company[:id]).select(:prev_tier, :tier, :fee)
    total_charge = (basic_fee[0].to_f + UsageCharge.calculate_charge(@usage, tiers)).ceil

    create_result(company[:provider_name], company[:plan_name], total_charge)
  end

  # 電気料金の結果を作成する
  #
  # @param [String] provider_name 企業名
  # @param [String] plan_name プラン名
  # @param [Integer, String] total_usage 合計料金
  # @return [Hash] 表示用のデータ
  def create_result(provider_name, plan_name, total_usage)
    {
      'provider_name': provider_name,
      'plan_name': plan_name,
      'price': total_usage
    }
  end
end