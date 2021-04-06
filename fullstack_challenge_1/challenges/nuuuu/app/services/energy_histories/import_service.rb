require 'csv'

module EnergyHistories
  class ImportService
    class InvalidCsvRecordError < StandardError
    end

    EnergyHistoryUnit = Struct.new(:line_number, :label, :house_user_id, :year, :month, :temperature, :daylight, :energy_production, :now) do
      def self.parse_from(csv_row, line_number, now)
        EnergyHistoryUnit.new(line_number,
                              Integer(csv_row[1], exception: false),
                              Integer(csv_row[2], exception: false),
                              Integer(csv_row[3], exception: false),
                              Integer(csv_row[4], exception: false),
                              Float(csv_row[5], exception: false),
                              Float(csv_row[6], exception: false),
                              Integer(csv_row[7], exception: false),
                              now
        )
      end

      def validate!(params)
        raise InvalidCsvRecordError, "labelが不正です [line:#{line_number}]" unless label.is_a?(Integer)
        raise InvalidCsvRecordError, "house_user_idが不正です [line:#{line_number}]" unless params[:house_user_ids].include?(house_user_id)

        # TODO: その他カラムもバリデーション入れる
        # valid.
      end

      def to_h
        {
          house_user_id: house_user_id,
          label: label,
          year: year,
          month: month,
          temperature: temperature,
          daylight: daylight,
          energy_production: energy_production,
          created_at: now,
          updated_at: now
        }
      end
    end

    def run(filepath)
      validation_params = {}
      validation_params[:house_user_ids] = Set.new(HouseUser.all.pluck(:id)) # TODO: user多すぎるとき要検討

      now = Time.current
      energy_histories = []

      CSV.open(filepath, 'r:UTF-8', headers: true, skip_blanks: true).each.with_index(1) do |csv_row, line_number|
        # TODO: csvレコード数がさらに多くなってメモリ不足とかになりそうなら、さらにサブループに分ける
        # active record インスタンス作成＆insertだと、大量データ時に時間空間計算コストが高いので、ARインスタンス生成せずbulk insertする
        energy_history = EnergyHistoryUnit.parse_from(csv_row, line_number, now)
        energy_history.validate!(validation_params) # TODO: invalid csv record を無視してもよい（いまは１行でも不正なら全エラー）
        energy_histories.push(energy_history.to_h)
      end

      # bulkでgo
      EnergyHistory.insert_all!(energy_histories)

      energy_histories.size
    end
  end
end
