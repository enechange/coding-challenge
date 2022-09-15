class Form::Plan::Simulate
  include ActiveModel::Model

  attr_accessor :ampere, :usage
  validates :ampere, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :usage, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def params
    {
      ampere: ampere.to_i,
      usage: usage.to_i
    }
  end
end
