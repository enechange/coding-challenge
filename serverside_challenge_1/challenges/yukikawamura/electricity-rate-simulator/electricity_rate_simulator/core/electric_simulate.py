import json
import logging
from pathlib import Path

from pydantic import ValidationError

from ..model import PlanContract, PlanUsage, ProFile, UserData
from ..exception import (
    ElectricSimulateClientError,
    ElectricSimulateProviderError,
    ElectricSimulationError,
    NotFoundContractError,
    NotFoundProviderError,
)

BASE_DIR = Path(__file__).parents[1]
DATA_DIR = BASE_DIR.joinpath("data")
PROVIDER_DIR = DATA_DIR.joinpath("provider")


def setup_logging(debug_mode=False):
    lgr = logging.getLogger("uvicorn.app")
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

    def simulate(self, user_data: UserData):

        simulations = []

        for profile in PROVIDER_DIR.glob("**/plan.json"):
            with open(profile, "r", encoding="utf-8") as f:
                provider_data = json.load(f)
                try:
                    provider_data = self._validate_profile(provider_data)
                    simulation = self._calculate_electricity_rate(
                        provider_data, user_data
                    )
                    simulations.append(simulation)
                except ElectricSimulationError as e:
                    lgr.exception(e)

        if not simulations:
            raise NotFoundProviderError("Not Found providers")

        return simulations

    def _validate_profile(self, profile_data: dict):
        try:
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
        except ValidationError as e:
            raise ElectricSimulationError(e)
            
        except ElectricSimulateProviderError as e:
            raise e

    def _calculate_electricity_rate(self, provider_data: ProFile, user_data: UserData):
        try:
            base_price = self._calculate_base_rate(
                provider_data.contracts, user_data.contract
            )
            usage_price = self._calculate_usage_rate(
                provider_data.usage, user_data.usage
            )

            if usage_price == 0:
                total_price = int(base_price / 2)
            else:
                total_price = int(base_price + usage_price)

            simulation = {
                "provider": provider_data.provider,
                "plan": provider_data.plan,
                "price": f"{total_price}円",
            }

            return simulation
        except (ElectricSimulateProviderError, ElectricSimulateClientError) as e:
            lgr.exception(e)
            raise e

    def _calculate_base_rate(self, contracts: list[PlanContract], contract: int):
        for item in contracts:
            if contract == item.contract:
                return item.price
        else:
            raise NotFoundContractError(f"Not found number of contract: {contract}")

    def _calculate_usage_rate(self, usages: list[PlanUsage], usage: int):

        usage_price = 0
        for plan_usage in usages:

            if plan_usage.over <= usage:
                if usage < plan_usage.until:
                    usage_price += (usage - plan_usage.over) * plan_usage.price
                else:  # usage >= until
                    usage_price += (
                        plan_usage.until - plan_usage.over
                    ) * plan_usage.price

        return usage_price
