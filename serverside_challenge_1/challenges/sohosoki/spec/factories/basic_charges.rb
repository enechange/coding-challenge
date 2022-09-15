FactoryBot.define do
  [10, 15, 20, 30, 40, 50, 60].each.with_index(1) do |a, i|
    factory a.to_s.to_sym, class: BasicCharge do
      ampere { a }
      price { 100 * i }
    end
  end
end
