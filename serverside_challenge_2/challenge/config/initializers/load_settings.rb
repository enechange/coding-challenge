# Rails 起動時に YAML ファイルを読み込む
require 'yaml'

ELECTRICITY_SETTINGS = begin
  yaml_file = Rails.root.join("config/api_settings.yml")
  raw_data = YAML.load_file(yaml_file)
  raw_data.fetch(Rails.env.to_s, [])
rescue Errno::ENOENT
  []  # ファイルがない場合は空配列
end