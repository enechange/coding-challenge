#環境別にseed ファイルを読み込む
load(Rails.root.join("db", "seeds", "#{Rails.env.downcase}.rb"))
