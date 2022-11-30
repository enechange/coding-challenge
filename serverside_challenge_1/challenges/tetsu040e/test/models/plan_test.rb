require 'minitest/autorun'
require 'test_helper'

class PlanTest < ActiveSupport::TestCase

  test 'calc_basic_price' do
    normalPlan = Plan.find(1)
    price = normalPlan.calc_basic_price(ampere: 10)
    assert price == 100
    price = normalPlan.calc_basic_price(ampere: 20)
    assert price == 200
    price = normalPlan.calc_basic_price(ampere: 5)
    assert price.nil?

    freePlan = Plan.find(2)
    price = freePlan.calc_basic_price(ampere: 10)
    assert price == 0

    invalidPlan = Plan.find(3)
    price = invalidPlan.calc_basic_price(ampere: 10)
    assert price.nil?
  end

  test 'calc_pay_per_use_price' do
    normalPlan = Plan.find(1)
    price = normalPlan.calc_pay_per_use_price(amount: 100)
    assert price == 1000
    price = normalPlan.calc_pay_per_use_price(amount: 101)
    assert price == 1020
    price = normalPlan.calc_pay_per_use_price(amount: 200)
    assert price == 3000
    price = normalPlan.calc_pay_per_use_price(amount: 201)
    assert price == 3030

    freePlan = Plan.find(2)
    price = freePlan.calc_pay_per_use_price(amount: 250)
    assert price == 5000

    invalidPlan = Plan.find(3)
    price = invalidPlan.calc_pay_per_use_price(amount: 100)
    assert price.nil?
  end

  test 'calc_total_value' do
    plan = Plan.new
    plan.stub(:calc_basic_price, 100) do
      plan.stub(:calc_pay_per_use_price, 100) do
        price = plan.calc_total_price(ampere: 10, amount: 200)
        assert price == 200
      end
    end

    plan.stub(:calc_basic_price, nil) do
      plan.stub(:calc_pay_per_use_price, 100) do
        price = plan.calc_total_price(ampere: 10, amount: 200)
        assert price.nil?
      end
    end

    plan.stub(:calc_basic_price, 100) do
      plan.stub(:calc_pay_per_use_price, nil) do
        price = plan.calc_total_price(ampere: 10, amount: 200)
        assert price.nil?
      end
    end
  end

end
