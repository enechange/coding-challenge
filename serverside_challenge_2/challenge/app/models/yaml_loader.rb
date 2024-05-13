class YamlLoader #provider data loader
  class << self
    def tepco_metered_light_b
      load_electricity_rate_plan('tepco_energy_partner_metered_light_b.yml')
    end

    def tepco_standard_s
      load_electricity_rate_plan('tepco_energy_partner_standard_s.yml')
    end

    def tokyo_gas_more_electricity_1
      load_electricity_rate_plan('tokyo_gas_more_electricity_1.yml')
    end

    def looop_home_plan
      load_electricity_rate_plan('looop_home_plan.yml')
    end

    private

    def load_electricity_rate_plan(file_name)
      path = Rails.root.join('config', 'electricity_rate_plans', file_name)

      raise 'ファイルが存在しません' unless File.exist?(path)
      raise 'ファイルが空です' if File.zero?(path)

      YAML.load_file(path)
    end
  end 
end