module NumericConverter
  extend ActiveSupport::Concern

  def convert_integer(str)
    if str.blank? || !str.match?(/^\d+$/)
      return str
    end

    str.to_i
  end
end
