class BillingPlan
  class Price
    include ActiveModel::Model

    attr_accessor :price_per_kwh, :threshold

    validates :price_per_kwh, presence: true
    validates :threshold, comparison: { greater_than_or_equal_to: 0 }, allow_nil: true

    def initialize(price_per_kwh: nil, threshold: nil)
      @price_per_kwh = price_per_kwh
      @threshold = threshold
    end
  end
end
