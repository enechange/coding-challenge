# frozen_string_literal: true

module Constants
  VALID_AMPERES = [10, 15, 20, 30, 40, 50, 60].freeze
  VALID_AMPERES_MORE_THAN_30 = [30, 40, 50, 60].freeze
  YAML_PATH = Rails.root.join('lib/data/charge_list.yml')
end
