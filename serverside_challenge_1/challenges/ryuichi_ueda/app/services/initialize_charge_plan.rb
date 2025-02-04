# frozen_string_literal: true

class InitializeChargePlan
  include Constants

  attr_reader :basic_charges, :tiers, :provider, :plan

  def initialize(provider, plan)
    @provider_data = self.class.load_providers[provider]
    @basic_charges = generate_basic_charges
    @tiers = generate_tiers
    @plan = plan || @provider_data['plan']
    @provider = provider
  end

  def self.load_providers
    @load_providers ||= YAML.load_file(YAML_PATH)['providers']
  end

  private

  def generate_basic_charges
    VALID_AMPERES.index_with do |ampere|
      @provider_data['basic_charges'][ampere]
    end.freeze
  end

  def generate_tiers
    @provider_data['tiers'].transform_keys do |key|
      key == 'Infinity' ? Float::INFINITY : key
    end.freeze
  end
end
