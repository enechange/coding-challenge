module CsvImports
  extend ActiveSupport::Concern

  module ClassMethods
    def import(file)
      row_count = 0
      import_file_error_flg = true

      return { Erorr: 'インポートが失敗しました。CSVファイルを指定してください。' } if file.blank?

      # CSVファイルのインポート
      begin
        ActiveRecord::Base.transaction do
          CSV.foreach(file.path, headers: true) do |row|
            # idを付与
            row_count += 1
            row["id"] = row_count
    
            # rowのカラムがupdatable_atributesと同じ場合のみ処理を実行
            row_keys = row.to_h.keys.sort
            if row_keys == updatable_attributes.sort
              record = find_by(id: row["id"]) || new
              record.attributes = row.to_hash.slice(*updatable_attributes)
              record.save!
            else
              import_file_error_flg = false
            end
          end
        end
      rescue
        return { Erorr: 'インポートが失敗しました。CSVファイルのデータ形式を見直してください。' }
      end

      # CSVインポート後のレスポンス
      if import_file_error_flg == false
        { Erorr: 'インポートが失敗しました。CSVファイルのデータ形式を見直してください。' }
      else
        { Success: 'インポートが成功しました。' }
      end
    end
  end
end