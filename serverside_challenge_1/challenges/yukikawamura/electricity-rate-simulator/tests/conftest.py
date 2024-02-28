import json
from pathlib import Path

import pytest
from electricity_rate_simulator.model import PlanContract, PlanUsage, ProFile, UserData

BASE_DIR = Path(__file__).parents[1]
DATA_DIR = BASE_DIR.joinpath("electricity_rate_simulator", "data")
PROVIDER_DIR = DATA_DIR.joinpath("provider")

TEST_DIR = BASE_DIR.joinpath("tests")
TEST_PROFILE = TEST_DIR.joinpath("assets", "test_plan.json")
TEST_PROFILE_INVAILED_CONTRACTS = TEST_DIR.joinpath(
    "assets", "test_plan_invalid_contracts.json"
)
TEST_PROFILE_INVAILED_USAGES = TEST_DIR.joinpath(
    "assets", "test_plan_invalid_usages.json"
)


@pytest.fixture()
def test_user_data():
    return UserData(contract=10, usage=100)


@pytest.fixture()
def test_profile():
    with open(TEST_PROFILE, "r", encoding="utf-8") as f:
        return json.load(f)


@pytest.fixture()
def test_profile_invalid_contracts():
    with open(TEST_PROFILE_INVAILED_CONTRACTS, "r", encoding="utf-8") as f:
        return json.load(f)


@pytest.fixture()
def test_plan():
    return _test_provider_file(TEST_PROFILE)


@pytest.fixture()
def test_usages():
    test_profile = _test_provider_file(TEST_PROFILE)
    return test_profile.usage


@pytest.fixture()
def test_contracts():
    test_profile = _test_provider_file(TEST_PROFILE)
    return test_profile.contracts


@pytest.fixture()
def test_contracts_invalid_data():
    test_profile = _test_provider_file(TEST_PROFILE_INVAILED_CONTRACTS)
    return test_profile.contracts


@pytest.fixture()
def test_plan_invlid_usages():
    return _test_provider_file(TEST_PROFILE_INVAILED_USAGES)


@pytest.fixture()
def test_usages_invalid_data():
    test_profile = _test_provider_file(TEST_PROFILE_INVAILED_USAGES)
    return test_profile.usage


@pytest.fixture()
def test_plan_by_tepco():
    profile = PROVIDER_DIR.joinpath("tepco", "plan.json")
    return _test_provider_file(profile)


@pytest.fixture()
def test_plan_by_looop():
    profile = PROVIDER_DIR.joinpath("looop", "plan.json")
    return _test_provider_file(profile)


@pytest.fixture()
def test_plan_by_tokyogas():
    profile = PROVIDER_DIR.joinpath("tokyo-gas", "plan.json")
    return _test_provider_file(profile)


@pytest.fixture()
def test_plan_by_jxtg_electricity():
    profile = PROVIDER_DIR.joinpath("jxtg-electric", "plan.json")
    return _test_provider_file(profile)


def _test_provider_file(profile: Path):
    with open(profile, "r", encoding="utf-8") as f:
        profile_data = json.load(f)
        contracts = [
            PlanContract(
                contract=contracts.get("contract"), price=contracts.get("price")
            )
            for contracts in profile_data.get("contracts")
        ]
        usages = [
            PlanUsage(
                over=usage.get("over"),
                until=usage.get("until"),
                price=usage.get("price"),
            )
            for usage in profile_data.get("usage")
        ]
        return ProFile(
            provider=profile_data.get("provider"),
            plan=profile_data.get("name"),
            contracts=contracts,
            usage=usages,
        )
