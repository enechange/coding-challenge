module ParamsConverter
  def convert_params(str)
    if str.match(/^[0-9]+$/)
      str.to_i
    else
      str
    end
  end
end