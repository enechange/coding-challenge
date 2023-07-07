module ApplicationHelper
  include Pagy::Frontend

  def exist_or_not(bool_value)
    bool_value ? 'あり' : 'なし'
  end
end
