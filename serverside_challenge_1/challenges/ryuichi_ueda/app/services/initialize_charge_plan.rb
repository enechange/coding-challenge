# frozen_string_literal: true

class InitializeChargePlan
  include Constants

  attr_reader :basic_charges, :tiers, :provider, :plan

  def initialize(provider)
    @providers_data = load_providers
    prepared_data = prepare_provider_data(provider)
    @basic_charges = prepared_data[:basic_charges]
    @tiers = prepared_data[:tiers]
    @provider = provider
    @plan = prepared_data[provider]
  end

  private

  def prepare_provider_data(provider)
    load_provider(provider)
    {
      basic_charges: generate_basic_charges,
      tiers: generate_tiers,
      **{ provider => generate_plan }
    }
  end

  def load_providers
    YAML.load_file(YAML_PATH)['providers']
  end

  def load_provider(provider)
    @provider_data = @providers_data[provider]
  end

  def generate_basic_charges
    VALID_AMPERES.index_with do |ampere|
      @provider_data['basic_charges'][ampere]
    end.freeze
  end

  def generate_tiers
    @provider_data['tiers'].transform_keys do |key|
      ['Infinity'].include?(key) ? Float::INFINITY : key
    end.freeze
  end

  def generate_plan
    @provider_data['plan']
  end
end
