import json
from pathlib import Path

from .exception import (
    InvalidContractError,
    InvalidContractsError,
    InvalidUsageError,
    InvalidUsagesError,
    NotFoundContractError,
    ElectricSimulationError,
    NotFoundProviderError
)

BASE_DIR = Path(
    "/workspaces/coding-challenge/serverside_challenge_1/challenges/yukikawamura/electricity-rate-simulator/electricity_rate_simulator"
)
DATA_DIR = BASE_DIR.joinpath("data")
PROVIDER_DIR = DATA_DIR.joinpath("provider")


def calc_plan(profile: Path, contract: int, usage: int):
    with open(profile, "r", encoding="utf-8") as f:
        plan = json.load(f)

        if not plan.get("contracts"):
            raise InvalidContractsError("Invailed contracts data")
        contracts = plan["contracts"]

        if not plan.get("usage"):
            raise InvalidUsagesError("Invalid usages data")
        usages = plan["usage"]

        base_price = calc_base_rate(contracts, contract)
        usage_price = calc_usage_rate(usages, usage)
        total_price = int(base_price + usage_price)

        simulation = {
            "provider": plan["provider"],
            "plan": plan["name"],
            "price": f"{total_price}円",
        }

        return simulation


def calc_base_rate(contracts: list[dict], contract: int):

    if not contracts:
        raise InvalidContractsError("Invailed contracts data")

    if contract < 0:
        raise InvalidContractError(f"Invailed number of contract: {contract}")

    for row in contracts:
        if contract == int(row["contract"]):
            return float(row["price"])
    else:
        raise NotFoundContractError(f"Not found number of contract: {contract}")


def calc_usage_rate(usages: dict, usage: int):

    if not usages:
        raise InvalidUsagesError("Invalid usages data")

    if usage < 0:
        raise InvalidUsageError(f"Invalid number of usage: {usage}")

    usage_price = 0
    for row in usages:
        over = row["over"]
        until = row["until"] if "until" in row else float("inf")
        price = row["price"]

        if over <= usage:
            if usage < until:
                usage_price += (usage - over) * price
            else:  # usage >= until
                usage_price += (until - over) * price

    return usage_price


def calc_electric_simulations(contract: int, usage: int):

    if contract < 0:
        raise InvalidContractError(f"Invailed number of contract: {contract}")

    if usage < 0:
        raise InvalidUsageError(f"Invalid number of usage: {usage}")

    simulations = []
    for profile in PROVIDER_DIR.glob("**/plan.json"):
        try:
            simulation = calc_plan(profile, contract, usage)
            simulations.append(simulation)
        except ElectricSimulationError as e:
            print(e)
    
    if not simulations:
        raise NotFoundProviderError("Not Found providers")

    return simulations


if __name__ == "__main__":
    calc_electric_simulations()
