from electricity_rate_simulator.model import UserData, PlanUsage, PlanContract

import pytest

from electricity_rate_simulator.exception import (
    InvalidContractError,
    InvalidContractsError,
    InvalidUsageError,
    InvalidUsageOverError,
    InvalidUsageUntilError,
    InvalidUsagePriceError,
    InvalidContractPriceError,
)


class TestUserData:

    def test_user_data(self):
        user_data = UserData(contract=10, usage=10)
        assert user_data.contract == 10
        assert user_data.usage == 10

    def test_contract_invalid_data(self):
        test_contract = 0
        err_msg = f"Invalid number of contract: {test_contract}"
        with pytest.raises(InvalidContractError) as e:
            UserData(contract=test_contract, usage=10)

        assert str(e.value) == err_msg

    def test_usage_invalid_data(self):
        test_usage = -1
        err_msg = f"Invalid number of usage: {test_usage}"
        with pytest.raises(InvalidUsageError) as e:
            UserData(contract=10, usage=test_usage)

        assert str(e.value) == err_msg


class TestPlanUsage:
    @pytest.mark.parametrize(
        "test_over, test_until, test_price",
        [((0, 100, 300), (100, 200, float("inf")), (10, 20, 30))],
    )
    def test_plan_usage(self, test_usages, test_over, test_until, test_price):
        for item in test_usages:
            assert item.over in test_over
            assert item.until in test_until
            assert item.price in test_price

    def test_plan_usage_invalid_over(self):
        err_msg = "Invalid over data"
        with pytest.raises(InvalidUsageOverError) as e:
            PlanUsage(over=-1, until=0, price=0)
        assert str(e.value) == err_msg

    def test_plan_usage_invalid_until(self):
        err_msg = "Invalid until data"
        with pytest.raises(InvalidUsageUntilError) as e:
            PlanUsage(over=0, until=-1, price=0)
        assert str(e.value) == err_msg

    def test_plan_usage_invalid_price(self):
        err_msg = "Invalid price data"
        with pytest.raises(InvalidUsagePriceError) as e:
            PlanUsage(over=0, until=0, price=-1)
        assert str(e.value) == err_msg


class TestPlanContract:
    @pytest.mark.parametrize(
        "test_contract, test_price",
        [((10, 15, 20, 30, 40, 50, 60), (10, 15, 20, 30, 40, 50, 60))],
    )
    def test_plan_contarct(self, test_contracts, test_contract, test_price):
        for items in test_contracts:
            assert items.contract in test_contract
            assert items.price in test_price

    def test_plan_contract_invalid_contracts(self):
        err_msg = "Invalid contracts data"
        with pytest.raises(InvalidContractsError) as e:
            PlanContract(contract=-1, price=10)
        assert str(e.value) == err_msg

    def test_plan_contract_invalid_price(self):
        err_msg = "Invalid price data"
        with pytest.raises(InvalidContractPriceError) as e:
            PlanContract(contract=10, price=-1)
        assert str(e.value) == err_msg


class TestProFile:

    def test_profile(self, test_plan):
        assert test_plan.provider == "Testでんき"
        assert test_plan.plan == "Testプラン"
        assert test_plan.contracts == [
            PlanContract(contract=10, price=10),
            PlanContract(contract=15, price=15),
            PlanContract(contract=20, price=20),
            PlanContract(contract=30, price=30),
            PlanContract(contract=40, price=40),
            PlanContract(contract=50, price=50),
            PlanContract(contract=60, price=60),
        ]
        assert test_plan.usage == [
            PlanUsage(over=0, until=100, price=10),
            PlanUsage(over=100, until=200, price=20),
            PlanUsage(over=300, until=None, price=30),
        ]

