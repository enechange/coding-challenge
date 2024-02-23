from electricity_rate_simulator.core.electric_simulate import (
    calc_electric_simulations,
    calc_plan,
    calc_base_rate,
    calc_usage_rate,
)

from electricity_rate_simulator.core.exception import (
    InvalidContractError,
    InvalidContractsError,
    InvalidUsageError,
    InvalidUsagesError,
    ElectricSimulationError,
)

from .conftest import (
    PROVIDER_DIR,
    TEST_PROFILE_INVAILED_CONTRACTS,
    TEST_PROFILE_INVAILED_USAGES,
    TEST_PROFILE,
)

import pytest


class TestElectricsimulations:
    def test_calc_electric_simulations_1(self):
        simulations = calc_electric_simulations(contract=10, usage=100)
        assert simulations == [
            {
                "provider": "東京電力エナジーパートナー",
                "plan": "従量電灯B",
                "price": "2274円",
            },
            {
                "provider": "Loopでんき",
                "plan": "おうちプラン",
                "price": "2640円",
            },
        ]

    def test_calc_electric_simulations_2(self):
        simulations = calc_electric_simulations(contract=30, usage=100)
        assert simulations == [
            {
                "provider": "東京電力エナジーパートナー",
                "plan": "従量電灯B",
                "price": "2846円",
            },
            {"provider": "東京ガス", "plan": "ずっとも電気1", "price": "4264円"},
            {"provider": "Loopでんき", "plan": "おうちプラン", "price": "2640円"},
            {
                "provider": "JXTGでんき",
                "plan": "従量電灯Bたっぷりプラン",
                "price": "2846円",
            },
        ]


class TestElectricSimurationExceptions:

    def test_calc_electric_simulations_invailed_contract(self):
        contract = -1
        usage = 100

        with pytest.raises(InvalidContractError) as e:
            calc_electric_simulations(contract, usage)

        assert str(e.value) == f"Invailed number of contract: {contract}"

    def test_calc_electric_simulations_invailed_usage(self):
        contract = 10
        usage = -1

        with pytest.raises(InvalidUsageError) as e:
            calc_electric_simulations(contract, usage)

        assert str(e.value) == f"Invalid number of usage: {usage}"

    def test_calc_plan_invailed_contract(self):
        profile = TEST_PROFILE
        contract = -1
        usage = 100

        with pytest.raises(ElectricSimulationError) as e:
            calc_plan(profile, contract, usage)

        assert str(e.value) == f"Invailed number of contract: {contract}"

    def test_calc_plan_invailed_usage(self):
        profile = TEST_PROFILE
        contract = 10
        usage = -1

        with pytest.raises(ElectricSimulationError) as e:
            calc_plan(profile, contract, usage)

        assert str(e.value) == f"Invalid number of usage: {usage}"

    def test_calc_plan_notfound_contract(self):
        profile = TEST_PROFILE
        contract = 0
        usage = 100

        with pytest.raises(ElectricSimulationError) as e:
            calc_plan(profile, contract, usage)

        assert str(e.value) == f"Not found number of contract: {contract}"

    def test_calc_plan_invailed_contracts_plan(self):
        profile = TEST_PROFILE_INVAILED_CONTRACTS
        contract = 10
        usage = 10

        with pytest.raises(InvalidContractsError) as e:
            calc_plan(profile, contract, usage)

        assert str(e.value) == "Invailed contracts data"

    def test_calc_plan_invailed_usages_plan(self):
        profile = TEST_PROFILE_INVAILED_USAGES
        contract = 10
        usage = 10

        with pytest.raises(InvalidUsagesError) as e:
            calc_plan(profile, contract, usage)

        assert str(e.value) == "Invalid usages data"


class TestElectricSimurationByTepco:
    contract = 10
    usage = 100
    profile = PROVIDER_DIR.joinpath("tepco", "plan.json")

    def test_calc_plan(self):

        simuration = calc_plan(self.profile, self.contract, self.usage)
        assert simuration == {
            "provider": "東京電力エナジーパートナー",
            "plan": "従量電灯B",
            "price": "2274円",
        }

    def test_calc_base_rate(self, test_plan_by_tepco):
        plan = test_plan_by_tepco
        contracts = plan["contracts"]
        base_price = calc_base_rate(contracts, self.contract)
        assert base_price == 286

    def test_calc_usage_rate(self, test_plan_by_tepco):
        plan = test_plan_by_tepco
        usages = plan["usage"]

        usage_price = calc_usage_rate(usages, self.usage)
        assert usage_price == 1988


class TestElectricSimurationByLooopElectricity:
    contract = 10
    usage = 100
    profile = PROVIDER_DIR.joinpath("looop", "plan.json")

    def test_calc_plan(self):
        simuration = calc_plan(self.profile, self.contract, self.usage)
        assert simuration == {
            "provider": "Loopでんき",
            "plan": "おうちプラン",
            "price": "2640円",
        }

    def test_calc_base_rate(self, test_plan_by_looop):
        plan = test_plan_by_looop
        contracts = plan["contracts"]
        base_price = calc_base_rate(contracts, self.contract)
        assert base_price == 0

    def test_calc_usage_rate(self, test_plan_by_looop):
        plan = test_plan_by_looop
        usages = plan["usage"]

        usage_price = calc_usage_rate(usages, self.usage)
        assert usage_price == 2640


class TestElectricSimurationByTokyoGas:
    contract = 30
    usage = 100
    profile = PROVIDER_DIR.joinpath("tokyo-gas", "plan.json")

    def test_calc_plan(self):
        simuration = calc_plan(self.profile, self.contract, self.usage)
        assert simuration == {
            "provider": "東京ガス",
            "plan": "ずっとも電気1",
            "price": "4264円",
        }

    def test_calc_base_rate(self, test_plan_by_tokyogas):
        plan = test_plan_by_tokyogas
        contracts = plan["contracts"]
        base_price = calc_base_rate(contracts, self.contract)
        assert base_price == 885.72

    def test_calc_usage_rate(self, test_plan_by_tokyogas):
        plan = test_plan_by_tokyogas
        usages = plan["usage"]

        usage_price = calc_usage_rate(usages, self.usage)
        assert usage_price == 3379


class TestElectricSimurationByJxtgElectricity:
    contract = 30
    usage = 100
    profile = PROVIDER_DIR.joinpath("jxtg-electric", "plan.json")

    def test_calc_plan(self):
        simuration = calc_plan(self.profile, self.contract, self.usage)
        assert simuration == {
            "provider": "JXTGでんき",
            "plan": "従量電灯Bたっぷりプラン",
            "price": "2846円",
        }

    def test_calc_base_rate(self, test_plan_by_jxtg_electricity):
        plan = test_plan_by_jxtg_electricity
        contracts = plan["contracts"]
        base_price = calc_base_rate(contracts, self.contract)
        assert base_price == 858.00

    def test_calc_usage_rate(self, test_plan_by_jxtg_electricity):
        plan = test_plan_by_jxtg_electricity
        usages = plan["usage"]

        usage_price = calc_usage_rate(usages, self.usage)
        assert usage_price == 1988
