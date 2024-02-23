class ValidateParamsService
  def initialize(amps, watts)
    @amps = amps
    @watts = watts
  end

  def validate_params
    errors = {}

    unless integer?(@amps) && integer?(@watts)
      errors['invalid_number'] = INVALID_NUMBER_ERROR
    end

    unless AMP_NUMBERS.include?(@amps.to_i)
      errors['invalid_amp'] = INVALID_AMP_ERROR
    end

    errors
  end

  private

  def integer?(param)
    /\A\d+\z/ === param
  end
end
