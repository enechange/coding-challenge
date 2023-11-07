# frozen_string_literal: true

class PricesService
  def create_response(ampere, volume, companies)
    companies.map.with_index do |company, _index|
      company['plans'].map do |plan|
        basic_price = caluculate_basic(ampere, plan['basics'])
        volume_price = caluculate_volume(volume, plan['volumes'])

        # 契約可能なアンペア数の場合のみレスポンスに含める
        if basic_price
          { 'provider_name' => company['name'], 'plan_name' => company['plans'][0]['name'],
            'price' => basic_price + volume_price }
        end
      end
    end.flatten.compact
  end

  def caluculate_basic(ampere, basics)
    plan = basics.find do |basic|
      basic['ampere'].to_i == ampere
    end
    # 契約可能なアンペア数でない場合はnilを返す
    plan ? plan['price'].to_i : nil
  end

  def caluculate_volume(value, volumes)
    price = volumes.reduce(0) do |sum, volume|
      max = volume['max'].to_i
      min = volume['min'].to_i
      price = volume['price'].to_f

      if min <= value
        # max以下の場合はvalue - minをpriceにかける
        if max >= value
          minus = value - min
          sum += minus * price
        end

        # maxを超えている場合はmax - minをpriceにかける
        if max < value
          minus = max - min
          sum += minus * price
        end

        # 上限値が設定されていない場合。一律料金の場合もここに到達する
        if max.zero?
          vol = value - max
          sum += vol * price
        end
      end
      sum
    end
    price.to_i
  end

  # 本来はmodelにバリデーションを書くべきだが、今回はサービスクラスに書く
  def validate_params(params)
    enabled_amperes = [10, 20, 30, 40, 50, 60]
    regex = /^[0-9]+$/
    errors = []

    errors.push({ 'code' => 'ampere_is_required', 'message' => 'アンペアは必須です' }) if params[:ampere].blank?

    errors.push({ code: 'volume_is_required', 'message' => '使用量は必須です' }) if params[:volume].blank?

    if params[:ampere].present? && enabled_amperes.exclude?(params[:ampere].to_i)
      errors.push({ code: 'invalid_ampere', 'message' => '契約対象外のアンペアです' })
    end

    if params[:volume].present? && params[:volume].to_f <= 0
      errors.push({ code: 'invalid_volume',
                    'message' => '使用量は0以上の値を入力してください' })
    end

    if params[:volume].present? && params[:volume].to_f && params[:volume].to_f.positive? && !regex.match?(params[:volume])
      errors.push({ code: 'not_integer',
                    'message' => '使用量は整数で入力してください' })
    end

    errors
  end
end
