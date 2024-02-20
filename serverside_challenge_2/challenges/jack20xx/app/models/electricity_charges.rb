class ElectricityCharges
  def initialize(amps, watts, charges_file)
    @amps = amps
    @watts = watts
    @charges = YAML.load_file(charges_file)
  end

  def provider_name
    @charges['provider_name']
  end

  def plan_name
    @charges['plan_name']
  end

  def calculate
    return 'no_data' if basic_charge.nil?

    basic_charge + usage_charge
  end

  private

  def basic_charge
    @charges['basic_charges'][@amps] || nil
  end

  def usage_charge
    charge = @charges['usage_charges'].values.find do |condition|
      @watts <= condition['limit']
    end

    @watts * charge['rate']
  end
end
