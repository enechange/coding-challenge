class GetChargesService
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
    conditions = @charges['usage_charges'].keys
    charge = 0

    conditions.each_with_index do |condition, index|
      prev_limit = index.zero? ? 0 : @charges['usage_charges'][conditions[index - 1]]['limit']
      curr_limit = @charges['usage_charges'][condition]['limit'] || @watts
      rate = @charges['usage_charges'][condition]['rate']

      if @watts > prev_limit
        charge += rate * ([curr_limit, @watts].min - prev_limit)
      end
    end

    charge
  end
end
