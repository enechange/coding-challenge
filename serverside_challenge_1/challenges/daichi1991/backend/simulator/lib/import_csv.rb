require "csv"

class ImportCsv

  def self.all_execute
    execute(model: Provider)
    execute(model: Plan)
    execute(model: BasicCharge)
    execute(model: CommodityCharge)
  end

  def self.execute(model:, file_name: nil)
    model_name = model.to_s.classify
    table_name = model_name.tableize
    file_name ||= table_name.singularize
    path = Rails.root.join("db/csv_data/#{file_name}.csv")

    list = []
    CSV.foreach(path, headers: true) do |row|
      list << row.to_h
    end
    

    
    model_name.constantize.import!(list, on_duplicate_key_update: :all)
    # ActiveRecord::Base.connection.execute("select setval('#{table_name}_id_seq',(select max(id) from #{table_name}))")
  end
end