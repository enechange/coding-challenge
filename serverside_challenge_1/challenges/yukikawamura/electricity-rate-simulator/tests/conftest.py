import pytest
import json
from pathlib import Path


BASE_DIR = Path(__file__).parents[1]
DATA_DIR = BASE_DIR.joinpath("electricity_rate_simulator", "data")
PROVIDER_DIR = DATA_DIR.joinpath("provider")

TEST_DIR = BASE_DIR.joinpath("tests")
TEST_PROFILE = TEST_DIR.joinpath("assets", "test_plan.json")
TEST_PROFILE_INVAILED_CONTRACTS = TEST_DIR.joinpath("assets", "test_plan_invalid_contracts.json")
TEST_PROFILE_INVAILED_USAGES = TEST_DIR.joinpath("assets", "test_plan_invalid_usages.json")


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
        return json.load(f)