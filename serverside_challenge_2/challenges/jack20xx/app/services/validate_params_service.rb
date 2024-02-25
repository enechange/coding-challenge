class ValidateParamsService
  def initialize(params)
    @params = params
  end

  def validate_params
    errors = {}

    begin
      amps = @params.require(:amps)
      watts = @params.require(:watts)
    rescue ActionController::ParameterMissing => e
      errors['invalid_parameter'] = "'#{e.param}'が正しくありません"
      return errors
    end

    unless integer?(amps) && integer?(watts)
      errors['invalid_number'] = INVALID_NUMBER_ERROR
    end

    unless AMP_NUMBERS.include?(amps.to_i)
      errors['unmatched_amp'] = INVALID_AMP_ERROR
    end

    errors
  end

  private

  def integer?(param)
    /\A\d+\z/ === param
  end
end
