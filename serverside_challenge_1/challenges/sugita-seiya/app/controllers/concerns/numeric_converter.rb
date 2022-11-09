module NumericConverter
  extend ActiveSupport::Concern

  def convert_integer(str)
    str.blank? || !str.match?(/^\d+$/) ? str : str.to_i
  end
end
