class BasicFee < ApplicationRecord
  belongs_to :plan

  with_options presence: true do
    validates :ampere
    validates :fee
  end

  class << self
    def csv_header_converters
      headers = {
        'PLAN_ID' => :plan_id,
        'AMPERE' => :ampere,
        'FEE' => :fee
      }
      lambda { |name| headers[name] }
    end
  end
end
