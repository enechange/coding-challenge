class UsageCharge < ApplicationRecord
  belongs_to :plan
  
  with_options presence: true do
    validates :from
    validates :unit_price
  end

  class << self
    def csv_header_converters
      headers = {
        'PLAN_ID' => :plan_id,
        'FROM' => :from,
        'TO' => :to,
        'UNIT_PRICE' => :unit_price
      }
      lambda { |name| headers[name] }
    end
  end
end
