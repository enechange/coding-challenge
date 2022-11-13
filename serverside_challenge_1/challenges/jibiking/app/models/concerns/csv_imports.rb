module CsvImports
  extend ActiveSupport::Concern

  module ClassMethods
    def import(file)
      row_count = 0
      import_row_error_count = 0
      import_file_error_count = 0

      if file
        # CSVファイルのインポート
        CSV.foreach(file.path, headers: true) do |row|
          
          # idを付与
          row_count += 1
          row["id"] = row_count
  
          # rowのカラムがupdatable_atributesと同じ場合のみ処理を実行
          row_keys = row.to_h.keys.sort
          if row_keys == updatable_attributes.sort
            record = find_by(id: row["id"]) || new
            record.attributes = row.to_hash.slice(*updatable_attributes)
            record.save
          else
            import_row_error_count += 1
          end
        end
      else
        import_file_error_count += 1
      end

      # CSVインポート後のレスポンス
      if import_row_error_count != 0
        { Erorr: 'インポートが失敗しました。CSVファイルのデータ形式を見直してください。' }
      elsif import_file_error_count != 0
        { Erorr: 'インポートが失敗しました。CSVファイルを指定してください。' }
      else
        { Success: 'インポートが成功しました。' }
      end
    end
  end
end