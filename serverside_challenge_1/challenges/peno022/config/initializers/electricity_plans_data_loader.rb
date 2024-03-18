# frozen_string_literal: true

require 'yaml'

file_path = Rails.root.join('config/electricity_plans.yml')
raise '電力プランファイルが存在しません' unless File.exist?(file_path)
raise '電力プランファイルが空です' if File.zero?(file_path)

PLANS = YAML.load_file(file_path)
