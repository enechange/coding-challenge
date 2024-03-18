class ValidateParamsService
  include ActiveModel::Validations

  attr_accessor :amps, :watts

  validates :amps, :watts, presence: true

  def initialize(params)
    @amps = params[:amps]
    @watts = params[:watts]
  end

  def validate_params
    @errors = {}

    show_param_name_error('amps') if amps.nil?
    show_param_name_error('watts') if watts.nil?
    return @errors unless @errors.empty?

    unless integer?(@amps) && integer?(@watts)
      @errors['invalid_number'] = I18n.t('errors.invalid_number')
    end

    unless AMP_NUMBERS.include?(@amps.to_i)
      @errors['unmatched_amp'] = I18n.t('errors.unmatched_amp', amps: AMP_NUMBERS.join(', '))
    end

    @errors
  end

  private

  def integer?(param)
    /\A\d+\z/ === param
  end

  def show_param_name_error(param)
    (@errors['invalid_parameter'] ||= []) << I18n.t('errors.invalid_parameter', param: param)
  end
end
