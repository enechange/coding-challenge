class CalculateChargesService
  def initialize(amps, watts)
    @amps = amps.to_i
    @watts = watts.to_i
  end

  def calculate_charges
    electricity_files = Dir.glob(ELECTRICITY_CHARGES_PATH)
    electricity_files.map do |file|
      charge = GetChargesService.new(@amps, @watts, file)
      price = charge.calculate
      {
        provider_name: charge.provider_name,
        plan_name: charge.plan_name,
        price: price.is_a?(Numeric) ? price.floor : price
      }
    end
  end
end
