import json
import logging
from pathlib import Path

from .exception import (
    ElectricSimulateClientError,
    ElectricSimulateProviderError,
    ElectricSimulationError,
    InvalidPlanError,
    InvalidProviderError,
    InvalidUsageOverError,
    InvalidUsagePriceError,
    InvalidContractError,
    InvalidContractsError,
    InvalidUsageError,
    InvalidUsagesError,
    NotFoundContractError,
    NotFoundProviderError,
)

BASE_DIR = Path(__file__).parents[1]
DATA_DIR = BASE_DIR.joinpath("data")
PROVIDER_DIR = DATA_DIR.joinpath("provider")


def setup_logging(debug_mode=False):
    lgr = logging.getLogger("uvicorn")
    log_format = "%(asctime)s:[%(levelname)s] %(message)s"
    stream_handler = logging.StreamHandler()
    stream_handler.setFormatter(log_format)
    level = logging.DEBUG if debug_mode else logging.INFO

    lgr.setLevel(level)
    lgr.addHandler(stream_handler)
    return lgr


lgr = setup_logging()


class ElectricSimulator(object):

    def __init__(self):
        pass

    def _validate_user_data(self, contract: int, usage: int):
        if contract <= 0:
            raise InvalidContractError(f"Invalid number of contract: {contract}")

        if usage < 0:
            raise InvalidUsageError(f"Invalid number of usage: {usage}")

    def simulate(self, contract: int, usage: int):

        simulations = []

        try:
            self._validate_user_data(contract, usage)
        except ElectricSimulateClientError as e:
            lgr.exception(e)
            raise e

        for profile in PROVIDER_DIR.glob("**/plan.json"):
            try:
                simulation = self._calculate_electricity_rate(profile, contract, usage)
                simulations.append(simulation)
            except ElectricSimulationError as e:
                lgr.exception(e)

        if not simulations:
            raise NotFoundProviderError("Not Found providers")

        return simulations

    def _validate_profile(self, profile_data: dict):
        if not profile_data.get("contracts"):
            raise InvalidContractsError("Invalid contracts data")

        if not profile_data.get("usage"):
            raise InvalidUsagesError("Invalid usages data")

        if not profile_data.get("provider"):
            raise InvalidProviderError("Invalid provider data")

        if not profile_data.get("name"):
            raise InvalidPlanError("Invalid plan data")

    def _calculate_electricity_rate(self, profile: Path, contract: int, usage: int):
        with open(profile, "r", encoding="utf-8") as f:
            profile_data = json.load(f)

            try:
                self._validate_profile(profile_data)
                contracts = profile_data["contracts"]
                usages = profile_data["usage"]
                provider: str = profile_data["provider"]
                plan: str = profile_data["name"]

                base_price = self._calculate_base_rate(contracts, contract)
                usage_price = self._calculate_usage_rate(usages, usage)

                if usage_price == 0:
                    total_price = int(base_price / 2)
                else:
                    total_price = int(base_price + usage_price)

                simulation = {
                    "provider": provider,
                    "plan": plan,
                    "price": f"{total_price}円",
                }

                return simulation
            except (ElectricSimulateProviderError, ElectricSimulateClientError) as e:
                lgr.exception(e)
                raise e

    def _calculate_base_rate(self, contracts: list[dict], contract: int):
        for row in contracts:
            if contract == int(row["contract"]):
                return float(row["price"])
        else:
            raise NotFoundContractError(f"Not found number of contract: {contract}")

    def _validate_usage_data(self, item: dict):
        if item.get("over", None) is None:
            raise InvalidUsageOverError("Invalid over data")

        if item.get("price", None) is None:
            raise InvalidUsagePriceError("Invalid price data")

    def _calculate_usage_rate(self, usages: dict, usage: int):

        usage_price = 0
        for item in usages:
            try:
                self._validate_usage_data(item)
            except InvalidUsagesError as e:
                raise e

            over: int = item["over"]
            until: int | float = item["until"] if "until" in item else float("inf")
            price = item["price"]

            if over <= usage:
                if usage < until:
                    usage_price += (usage - over) * price
                else:  # usage >= until
                    usage_price += (until - over) * price

        return usage_price
