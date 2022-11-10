module Common
  extend ActiveSupport::Concern

  module ClassMethods
    def import(file)
      import_error_count = 0

      # CSVファイルのインポート
      CSV.foreach(file.path, headers: true) do |row|
        # rowのカラムがupdatable_atributesと同じ場合のみ処理を実行
        row_keys = row.to_h.keys
        if row_keys == updatable_attributes
          record = find_by(id: row["id"]) || new
          record.attributes = row.to_hash.slice(*updatable_attributes)
          record.save
        else
          import_error_count += 1
        end
      end

      # CSVインポート後のレスポンス
      if import_error_count  != 0
        { Erorr: 'インポートが失敗しました。CSVファイルのデータ形式を見直してください。' }
      else
        { Success: 'インポートが成功しました。' }
      end
    end
  end
end