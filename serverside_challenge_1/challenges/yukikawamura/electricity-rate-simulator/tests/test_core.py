from electricity_rate_simulator.core.electric_simulate import (
    calc_electric_simulations,
    calc_plan,
    calc_base_rate,
    calc_usage_rate,
)
import pytest
import json
from pathlib import Path

BASE_DIR = Path(__file__).parents[1]
DATA_DIR = BASE_DIR.joinpath("electricity_rate_simulator/data")
PROVIDER_DIR = DATA_DIR.joinpath("provider")


class TestElectricsimulations:
    def test_calc_electric_simulations_1(self):
        contract = 10
        usage = 100
        simulations = calc_electric_simulations(contract, usage)
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
        contract = 30
        usage = 100
        simulations = calc_electric_simulations(contract, usage)
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

    def test_calc_base_rate(self):
        with open(self.profile, "r", encoding="utf-8") as f:
            plan = json.load(f)
            contracts = plan["contracts"]
            base_price = calc_base_rate(contracts, self.contract)
            assert base_price == 286

    def test_calc_usage_rate(self):
        with open(self.profile, "r", encoding="utf-8") as f:
            plan = json.load(f)
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

    def test_calc_base_rate(self):
        with open(self.profile, "r", encoding="utf-8") as f:
            plan = json.load(f)
            contracts = plan["contracts"]
            base_price = calc_base_rate(contracts, self.contract)
            assert base_price == 0

    def test_calc_usage_rate(self):
        with open(self.profile, "r", encoding="utf-8") as f:
            plan = json.load(f)
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

    def test_calc_base_rate(self):
        with open(self.profile, "r", encoding="utf-8") as f:
            plan = json.load(f)
            contracts = plan["contracts"]
            base_price = calc_base_rate(contracts, self.contract)
            assert base_price == 885.72

    def test_calc_usage_rate(self):
        with open(self.profile, "r", encoding="utf-8") as f:
            plan = json.load(f)
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

    def test_calc_base_rate(self):
        with open(self.profile, "r", encoding="utf-8") as f:
            plan = json.load(f)
            contracts = plan["contracts"]
            base_price = calc_base_rate(contracts, self.contract)
            assert base_price == 858.00

    def test_calc_usage_rate(self):
        with open(self.profile, "r", encoding="utf-8") as f:
            plan = json.load(f)
            usages = plan["usage"]

            usage_price = calc_usage_rate(usages, self.usage)
            assert usage_price == 1988
