from electricity_rate_simulator.core.electric_simulate import ElectricSimulator

from electricity_rate_simulator.core.exception import (
    InvalidContractError,
    InvalidContractsError,
    InvalidUsageError,
    InvalidUsagesError,
    ElectricSimulationError,
    ElectricSimulateProviderError,
    InvalidProviderError,
    InvalidPlanError,
    ElectricSimulateClientError,
    NotFoundProviderError,
    NotFoundContractError,
    InvalidUsageOverError,
    InvalidUsagePriceError,
)

from .conftest import (
    PROVIDER_DIR,
    TEST_PROFILE_INVAILED_CONTRACTS,
    TEST_PROFILE_INVAILED_USAGES,
    TEST_PROFILE,
)

import pytest
from pytest_mock.plugin import MockerFixture


class TestElectricSimulatior:

    electric_simurator = ElectricSimulator()

    def test_simulate_by_contract_10A(self):
        simulations = self.electric_simurator.simulate(contract=10, usage=100)
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

    def test_simulate_by_contract_30A(self):
        simulations = self.electric_simurator.simulate(contract=30, usage=100)
        assert simulations == [
            {
                "provider": "東京電力エナジーパートナー",
                "plan": "従量電灯B",
                "price": "2846円",
            },
            {"provider": "東京ガス", "plan": "ずっとも電気1", "price": "3225円"},
            {"provider": "Loopでんき", "plan": "おうちプラン", "price": "2640円"},
            {
                "provider": "JXTGでんき",
                "plan": "従量電灯Bたっぷりプラン",
                "price": "2846円",
            },
        ]


class TestElectricSimurationExceptions:
    profile = TEST_PROFILE
    contract = 10
    usage = 100
    electric_simuratior = ElectricSimulator()

    def test_simulate_invalid_contract_error(self, mocker: MockerFixture):
        err_msg = "dummy InvalidContractError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator.simulate",
            side_effect=InvalidContractError(err_msg),
        )
        with pytest.raises(ElectricSimulationError) as e:
            self.electric_simuratior.simulate(self.contract, self.usage)

        assert str(e.value) == err_msg

    def test_simulate_invalid_usage_error(self, mocker: MockerFixture):
        err_msg = "dummy InvalidUsageError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator.simulate",
            side_effect=InvalidUsageError(err_msg),
        )
        with pytest.raises(InvalidUsageError) as e:
            self.electric_simuratior.simulate(self.contract, self.usage)

        assert str(e.value) == err_msg

    def test_simulate_notfound_provider_error(self, mocker: MockerFixture):
        err_msg = "dummy NotFoundProviderError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator.simulate",
            side_effect=NotFoundProviderError("dummy NotFoundProviderError"),
        )
        with pytest.raises(NotFoundProviderError) as e:
            self.electric_simuratior.simulate()

        assert str(e.value) == err_msg

    def test_calculate_electricity_rate_invalid_contracts_error(
        self, mocker: MockerFixture
    ):
        err_msg = "dummy InvalidContractsError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator._calculate_electricity_rate",
            side_effect=InvalidContractsError(err_msg),
        )
        with pytest.raises(ElectricSimulateProviderError) as e:
            self.electric_simuratior._calculate_electricity_rate(self.profile)
        assert str(e.value) == err_msg

    def test_calculate_electricity_rate_invalid_usages_error(
        self, mocker: MockerFixture
    ):
        err_msg = "dummy InvalidUsagesError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator._calculate_electricity_rate",
            side_effect=InvalidUsagesError(err_msg),
        )
        with pytest.raises(ElectricSimulateProviderError) as e:
            self.electric_simuratior._calculate_electricity_rate(self.profile)
        assert str(e.value) == err_msg

    def test_calculate_electricity_rate_invalid_provider_error(
        self, mocker: MockerFixture
    ):
        err_msg = "dummy InvalidProviderError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator._calculate_electricity_rate",
            side_effect=InvalidProviderError(err_msg),
        )
        with pytest.raises(ElectricSimulateProviderError) as e:
            self.electric_simuratior._calculate_electricity_rate(self.profile)

        assert str(e.value) == err_msg

    def test_calculate_electricity_rate_invalid_plan_error(
        self, mocker: MockerFixture
    ):
        err_msg = "dummy InvalidPlanError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator._calculate_electricity_rate",
            side_effect=InvalidPlanError(err_msg),
        )
        with pytest.raises(ElectricSimulateProviderError) as e:
            self.electric_simuratior._calculate_electricity_rate(self.profile)

        assert str(e.value) == err_msg

    def test_calculate_electricity_rate_invalid_usage_error(
        self, mocker: MockerFixture
    ):
        err_msg = "dummy ElectricSimulateProviderError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator._calculate_electricity_rate",
            side_effect=ElectricSimulateProviderError(err_msg),
        )
        with pytest.raises(ElectricSimulateProviderError) as e:
            self.electric_simuratior._calculate_electricity_rate(self.profile)

        assert str(e.value) == err_msg

    def test_calculate_electricity_rate_notfound_contract_error(
        self, mocker: MockerFixture
    ):
        err_msg = "dummy ElectricSimulateClientError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator._calculate_electricity_rate",
            side_effect=ElectricSimulateClientError(err_msg),
        )
        with pytest.raises(ElectricSimulateClientError) as e:
            self.electric_simuratior._calculate_electricity_rate(self.profile)

        assert str(e.value) == err_msg

    def test_calculate_base_rate_notfound_contract_error(self, mocker: MockerFixture):
        err_msg = "dummy NotFoundContractError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator._calculate_base_rate",
            side_effect=NotFoundContractError(err_msg),
        )
        contracts = [{}]
        with pytest.raises(NotFoundContractError) as e:
            self.electric_simuratior._calculate_base_rate(contracts)

        assert str(e.value) == err_msg

    def test_calculate_usage_rate_invalid_usage_over_error(
        self, mocker: MockerFixture
    ):
        err_msg = "dummy InvalidUsageOverError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator._calculate_usage_rate",
            side_effect=InvalidUsageOverError(err_msg),
        )
        contracts = [{}]
        with pytest.raises(InvalidUsageOverError) as e:
            self.electric_simuratior._calculate_usage_rate(contracts)

        assert str(e.value) == err_msg

    def test_calculate_usage_rate_invalid_usage_price_error(
        self, mocker: MockerFixture
    ):
        err_msg = "dummy InvalidUsagePriceError"
        mocker.patch(
            "electricity_rate_simulator.core.electric_simulate.ElectricSimulator._calculate_usage_rate",
            side_effect=InvalidUsagePriceError(err_msg),
        )
        contracts = [{}]
        with pytest.raises(InvalidUsagePriceError) as e:
            self.electric_simuratior._calculate_usage_rate(contracts)

        assert str(e.value) == err_msg


class TestElectricSimurationByTepco:

    electric_simuratior = ElectricSimulator()

    @pytest.mark.parametrize(
        "test_contract, test_usage, test_price",
        [
            (15, 120, 2814),
            (15, 300, 7581),
            (15, 350, 9109),
            (20, 120, 2957),
            (20, 300, 7724),
            (20, 350, 9252),
            (30, 120, 3243),
            (30, 300, 8010),
            (30, 350, 9538),
            (40, 120, 3529),
            (40, 300, 8296),
            (40, 350, 9824),
            (50, 120, 3815),
            (50, 300, 8582),
            (50, 350, 10110),
            (60, 120, 4101),
            (60, 300, 8868),
            (60, 350, 10396),
        ],
    )
    def test_calculate_electricity_rate(self, test_contract, test_usage, test_price):
        profile = PROVIDER_DIR.joinpath("tepco", "plan.json")
        simuration = self.electric_simuratior._calculate_electricity_rate(
            profile, test_contract, test_usage
        )
        assert simuration == {
            "provider": "東京電力エナジーパートナー",
            "plan": "従量電灯B",
            "price": f"{test_price}円",
        }

    @pytest.mark.parametrize(
        "test_contract, test_price",
        [
            (10, 286.0),
            (15, 429.0),
            (20, 572.0),
            (30, 858.0),
            (40, 1144.0),
            (50, 1430.0),
            (60, 1716.0),
        ],
    )
    def test_calculate_base_rate(self, test_plan_by_tepco, test_contract, test_price):
        contracts = test_plan_by_tepco["contracts"]
        base_price = self.electric_simuratior._calculate_base_rate(
            contracts, test_contract
        )
        assert base_price == test_price

    @pytest.mark.parametrize(
        "test_usage, test_price",
        [(120, 2385.6), (300, 7152), (350, 8680.5)],
    )
    def test_calculate_usage_rate(self, test_plan_by_tepco, test_usage, test_price):
        usages = test_plan_by_tepco["usage"]
        usage_price = self.electric_simuratior._calculate_usage_rate(usages, test_usage)
        assert usage_price == test_price


class TestElectricSimurationByLooopElectricity:

    electric_simuratior = ElectricSimulator()

    @pytest.mark.parametrize(
        "test_contract, test_usage, test_price",
        [
            (10, 100, 2640),
            (10, 300, 7920),
            (10, 500, 13200),
            (15, 100, 2640),
            (15, 300, 7920),
            (15, 500, 13200),
            (20, 100, 2640),
            (20, 300, 7920),
            (20, 500, 13200),
            (30, 100, 2640),
            (30, 300, 7920),
            (30, 500, 13200),
            (40, 100, 2640),
            (40, 300, 7920),
            (40, 500, 13200),
            (50, 100, 2640),
            (50, 300, 7920),
            (50, 500, 13200),
            (60, 100, 2640),
            (60, 300, 7920),
            (60, 500, 13200),
        ],
    )
    def test_calculate_electricity_rate(self, test_contract, test_usage, test_price):
        profile = PROVIDER_DIR.joinpath("looop", "plan.json")
        simuration = self.electric_simuratior._calculate_electricity_rate(
            profile, test_contract, test_usage
        )
        assert simuration == {
            "provider": "Loopでんき",
            "plan": "おうちプラン",
            "price": f"{test_price}円",
        }

    @pytest.mark.parametrize(
        "test_contract, test_price",
        [(10, 0), (15, 0), (20, 0), (30, 0), (40, 0), (50, 0), (60, 0)],
    )
    def test_calculate_base_rate(self, test_plan_by_looop, test_contract, test_price):
        contracts = test_plan_by_looop["contracts"]
        base_price = self.electric_simuratior._calculate_base_rate(
            contracts, test_contract
        )
        assert base_price == test_price

    @pytest.mark.parametrize(
        "test_usage, test_price",
        [(100, 2640), (300, 7920), (500, 13200)],
    )
    def test_calculate_usage_rate(self, test_plan_by_looop, test_usage, test_price):
        usages = test_plan_by_looop["usage"]
        usage_price = self.electric_simuratior._calculate_usage_rate(usages, test_usage)
        assert usage_price == test_price


class TestElectricSimurationByTokyoGas:

    electric_simuratior = ElectricSimulator()

    @pytest.mark.parametrize(
        "test_contract, test_usage, test_price",
        [
            (30, 0, 429),
            (30, 140, 4171),
            (30, 350, 9186),
            (30, 400, 10507),
            (40, 0, 572),
            (40, 140, 4457),
            (40, 350, 9472),
            (40, 400, 10793),
            (50, 0, 715),
            (50, 140, 4743),
            (50, 350, 9758),
            (50, 400, 11079),
            (60, 0, 858),
            (60, 140, 5029),
            (60, 350, 10044),
            (60, 400, 11365),
        ],
    )
    def test_calculate_electricity_rate(self, test_contract, test_usage, test_price):
        profile = PROVIDER_DIR.joinpath("tokyo-gas", "plan.json")
        simuration = self.electric_simuratior._calculate_electricity_rate(
            profile, test_contract, test_usage
        )
        assert simuration == {
            "provider": "東京ガス",
            "plan": "ずっとも電気1",
            "price": f"{test_price}円",
        }

    @pytest.mark.parametrize(
        "test_contract, test_price",
        [(30, 858.00), (40, 1144.00), (50, 1430.00), (60, 1716.00)],
    )
    def test_calculate_base_rate(
        self, test_plan_by_tokyogas, test_contract, test_price
    ):
        contracts = test_plan_by_tokyogas["contracts"]
        base_price = self.electric_simuratior._calculate_base_rate(
            contracts, test_contract
        )
        assert base_price == test_price

    @pytest.mark.parametrize(
        "test_usage, test_price",
        [(0, 0), (140, 3313.8), (350, 8328.6), (400, 9649.1)],
    )
    def test_calculate_usage_rate(self, test_plan_by_tokyogas, test_usage, test_price):
        usages = test_plan_by_tokyogas["usage"]
        usage_price = self.electric_simuratior._calculate_usage_rate(usages, test_usage)
        assert usage_price == test_price


class TestElectricSimurationByJxtgElectricity:

    electric_simuratior = ElectricSimulator()

    @pytest.mark.parametrize(
        "test_contract, test_usage, test_price",
        [
            (30, 0, 429),
            (30, 120, 3243),
            (30, 300, 8010),
            (30, 600, 15534),
            (30, 650, 16841),
            (40, 0, 572),
            (40, 120, 3529),
            (40, 300, 8296),
            (40, 600, 15820),
            (40, 650, 17127),
            (50, 0, 715),
            (50, 120, 3815),
            (50, 300, 8582),
            (50, 600, 16106),
            (50, 650, 17413),
            (60, 0, 858),
            (60, 120, 4102),
            (60, 300, 8868),
            (60, 600, 16392),
            (60, 650, 17700),
        ],
    )
    def test_calculate_electricity_rate(self, test_contract, test_usage, test_price):
        profile = PROVIDER_DIR.joinpath("jxtg-electric", "plan.json")
        simuration = self.electric_simuratior._calculate_electricity_rate(
            profile, test_contract, test_usage
        )
        assert simuration == {
            "provider": "JXTGでんき",
            "plan": "従量電灯Bたっぷりプラン",
            "price": f"{test_price}円",
        }

    @pytest.mark.parametrize(
        "test_contract, test_price",
        [(30, 858.00), (40, 1144.00), (50, 1430.00), (60, 1716.80)],
    )
    def test_calculate_base_rate(
        self, test_plan_by_jxtg_electricity, test_contract, test_price
    ):
        contracts = test_plan_by_jxtg_electricity["contracts"]
        base_price = self.electric_simuratior._calculate_base_rate(
            contracts, test_contract
        )
        assert base_price == test_price

    @pytest.mark.parametrize(
        "test_usage, test_price",
        [(0, 0), (120, 2385.6), (300, 7152), (600, 14676), (650, 15983.5)],
    )
    def test_calculate_usage_rate(
        self, test_plan_by_jxtg_electricity, test_usage, test_price
    ):
        usages = test_plan_by_jxtg_electricity["usage"]
        usage_price = self.electric_simuratior._calculate_usage_rate(usages, test_usage)
        assert usage_price == test_price
