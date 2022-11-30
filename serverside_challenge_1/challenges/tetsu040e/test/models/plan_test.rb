require 'minitest/autorun'
require 'test_helper'

class PlanTest < ActiveSupport::TestCase

  ## test for calc_basic_price

  test "[normal_plan] calc_basic_price 10" do
    plan = Plan.find(1)
    price = plan.calc_basic_price(ampere: 10)
    assert price == 100
  end

  test "[normal_plan] calc_basic_price 20" do
    plan = Plan.find(1)
    price = plan.calc_basic_price(ampere: 20)
    assert price == 200
  end

  test "[normal_plan] calc_basic_price not set ampere 5" do
    plan = Plan.find(1)
    price = plan.calc_basic_price(ampere: 5)
    assert price.nil?
  end

  test "[free_plan] calc_basic_price 10" do
    plan = Plan.find(2)
    price = plan.calc_basic_price(ampere: 10)
    assert price == 0
  end

  test "[invalid_plan] calc_basic_price" do
    plan = Plan.find(3)
    price = plan.calc_basic_price(ampere: 10)
    assert price.nil?
  end

  ## test for calc_pay_per_use_price

  test "[normal_plan] calc_pay_per_use_price 50" do
    plan = Plan.find(1)
    price = plan.calc_pay_per_use_price(amount: 50)
    assert price == 500
  end

  test "[normal_plan] calc_pay_per_use_price 100" do
    plan = Plan.find(1)
    price = plan.calc_pay_per_use_price(amount: 100)
    assert price == 1000
  end

  test "[normal_plan] calc_pay_per_use_price 101" do
    plan = Plan.find(1)
    price = plan.calc_pay_per_use_price(amount: 101)
    assert price == 1020
  end

  test "[normal_plan] calc_pay_per_use_price 200" do
    plan = Plan.find(1)
    price = plan.calc_pay_per_use_price(amount: 200)
    assert price == 3000
  end

  test "[normal_plan] calc_pay_per_use_price 201" do
    plan = Plan.find(1)
    price = plan.calc_pay_per_use_price(amount: 201)
    assert price == 3030
  end

  test "[free_plan] calc_pay_per_use_price 250" do
    plan = Plan.find(2)
    price = plan.calc_pay_per_use_price(amount: 250)
    assert price == 5000
  end

  test "[invalid_plan] calc_pay_per_use_price" do
    plan = Plan.find(3)
    price = plan.calc_pay_per_use_price(amount: 100)
    assert price.nil?
  end

  ## test for calc_total_value

  test "calc_total_value valid" do
    plan = Plan.new
    plan.stub(:calc_basic_price, 100) do
      plan.stub(:calc_pay_per_use_price, 100) do
        price = plan.calc_total_price(ampere: 10, amount: 200)
        assert price == 200
      end
    end
  end

  test "calc_total_value basic_price nil" do
    plan = Plan.new
    plan.stub(:calc_basic_price, nil) do
      plan.stub(:calc_pay_per_use_price, 100) do
        price = plan.calc_total_price(ampere: 10, amount: 200)
        assert price.nil?
      end
    end
  end

  test "calc_total_value pay_per_use_price nil" do
    plan = Plan.new
    plan.stub(:calc_basic_price, 100) do
      plan.stub(:calc_pay_per_use_price, nil) do
        price = plan.calc_total_price(ampere: 10, amount: 200)
        assert price.nil?
      end
    end
  end

end
