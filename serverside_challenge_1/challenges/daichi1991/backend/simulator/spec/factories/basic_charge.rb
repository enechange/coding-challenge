FactoryBot.define do

  factory :data1, class: BasicCharge do
    plan_id 1
    ampere 20
    charge 572.00
  end

  factory :data2, class: BasicCharge do
    plan_id 1
    ampere 30
    charge 858.00
  end

  factory :data3, class: BasicCharge do
    plan_id 2
    ampere 20
    charge 0.00
  end

  factory :data4, class: BasicCharge do
    plan_id 2
    ampere 30
    charge 0.00
  end

  factory :data5, class: BasicCharge do
    plan_id 3
    ampere 30
    charge 858.00
  end

  factory :data6, class: BasicCharge do
    plan_id 4
    ampere 30
    charge 858.00
  end

end