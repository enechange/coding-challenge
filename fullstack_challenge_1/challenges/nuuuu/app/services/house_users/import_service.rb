require 'csv'

module HouseUsers
  class ImportService
    class ImportError < StandardError
    end

    HouseUserUnit = Struct.new(:line_number, :first_name, :last_name, :city, :num_of_people, :has_child, :now) do
      def self.parse_from(csv_row, line_number, now)
        HouseUserUnit.new(line_number,
                          csv_row[1],
                          csv_row[2],
                          csv_row[3],
                          Integer(csv_row[4], exception: false),
                          (case csv_row[5]
                           when 'Yes'
                             true
                           when 'No'
                             false
                           end),
                          now
        )
      end

      def validate!
        raise ImportError, "num_of_peopleが不正です [line:#{line_number}]" unless num_of_people.is_a?(Integer)
        raise ImportError, "has_childが不正です [line:#{line_number}]" if has_child.nil?

        # TODO: その他カラムもバリデーション入れる
        # valid.
      end

      def to_h
        {
          first_name: first_name,
          last_name: last_name,
          city: city,
          num_of_people: num_of_people,
          has_child: has_child,
          created_at: now,
          updated_at: now
        }
      end
    end

    def run(filepath)

      now = Time.current
      house_users = []

      CSV.open(filepath, 'r:UTF-8', headers: true, skip_blanks: true).each.with_index(1) do |csv_row, line_number|
        # TODO: csvレコード数がさらに多くなってメモリ不足とかになりそうなら、さらにサブループに分ける
        # active record インスタンス作成＆insertだと、大量データ時に時間空間計算コストが高いので、ARインスタンス生成せずbulk insertする
        house_user = HouseUserUnit.parse_from(csv_row, line_number, now)
        house_user.validate! # TODO: invalid csv record を無視してもよい（いまは１行でも不正なら全エラー）
        house_users.push(house_user.to_h)
      end

      # bulkでgo
      begin
        HouseUser.insert_all!(house_users)
      rescue => e
        # todo: システムの生情報がe.messageに入っているので、システムユーザーに必要なものだけ実際には出す
        raise ImportError, e.message
      end

      house_users.size
    end
  end
end
