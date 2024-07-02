class BillingPlan
  class Category
    include ActiveModel::Model

    attr_accessor :amperage, :base_charge

    validates :amperage, presence: true, acceptance: { accept: [10, 15, 20, 30, 40, 50, 60] }
    validates :base_charge, presence: true, comparison: { greater_than_or_equal_to: 0 }

    def initialize(amperage: nil, base_charge: nil)
      @amperage = amperage
      @base_charge = base_charge
    end
  end
end
