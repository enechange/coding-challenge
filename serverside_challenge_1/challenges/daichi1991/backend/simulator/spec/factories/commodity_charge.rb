FactoryBot.define do

  factory :data1, class: Plan do
    plan_id 1
    min_amount 1
    max_amount 120
    unit_price 19.88
  end

  factory :data2, class: Plan do
    plan_id 1
    min_amount 121
    max_amount 300
    unit_price 26.48
  end

  factory :data3, class: Plan do
    plan_id 1
    min_amount 301
    max_amount 999999999
    unit_price 30.57
  end

  factory :data4, class: Plan do
    plan_id 2
    min_amount 1
    max_amount 999999999
    unit_price 26.40
  end

end