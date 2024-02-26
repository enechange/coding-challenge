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
      errors['invalid_parameter'] = I18n.t('errors.invalid_parameter', param: e.param)
      return errors
    end

    unless integer?(amps) && integer?(watts)
      errors['invalid_number'] = I18n.t('errors.invalid_number')
    end

    unless AMP_NUMBERS.include?(amps.to_i)
      errors['unmatched_amp'] = I18n.t('errors.unmatched_amp', amps: AMP_NUMBERS.join(', '))
    end

    errors
  end

  private

  def integer?(param)
    /\A\d+\z/ === param
  end
end
