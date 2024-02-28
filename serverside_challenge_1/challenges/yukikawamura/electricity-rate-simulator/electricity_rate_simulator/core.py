import json

from pydantic import ValidationError

from .exception import (
    ElectricSimulateClientError,
    ElectricSimulateProviderError,
    ElectricSimulationError,
    NotFoundContractError,
    NotFoundProviderError,
)
from .model import PlanContract, PlanUsage, ProFile, UserData
from .utils import PROVIDER_DIR, setup_logging

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
            contracts = self._validate_plan_contract(profile_data.get("contracts"))
            usages = self._validate_plan_usage(profile_data.get("usage"))

            return ProFile(
                provider=profile_data.get("provider"),
                plan=profile_data.get("name"),
                contracts=contracts,
                usage=usages,
            )
        except ValidationError as e:
            raise ElectricSimulateProviderError(e)

        except ElectricSimulateProviderError as e:
            raise e

    def _validate_plan_contract(self, contracts: list[dict]):
        plan_contracts = []
        for contract in contracts:
            try:
                plan_contract = PlanContract(
                    contract=contract.get("contract"), price=contract.get("price")
                )
                plan_contracts.append(plan_contract)
            except ValidationError as e:
                raise ElectricSimulateProviderError(e)

        if not plan_contracts:
            raise ElectricSimulateProviderError("Not Found plan contracts.")

        return plan_contracts

    def _validate_plan_usage(self, usage):
        plan_usages = []
        for item in usage:
            plan_usage = PlanUsage(
                over=item.get("over"),
                until=item.get("until"),
                price=item.get("price"),
            )
            plan_usages.append(plan_usage)

        if not plan_usages:
            raise ElectricSimulateProviderError("Not found plan usages.")

        return plan_usages

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
        except ElectricSimulateClientError as e:
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
