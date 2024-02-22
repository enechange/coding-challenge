from pathlib import Path
import json

BASE_DIR = Path(
    "/workspaces/coding-challenge/serverside_challenge_1/challenges/yukikawamura/electricity-rate-simulator/electricity_rate_simulator"
)
DATA_DIR = BASE_DIR.joinpath("data")
PROVIDER_DIR = DATA_DIR.joinpath("provider")


def calc_plan(profile: Path, contract: int, usage: int):
    with open(profile, "r", encoding="utf-8") as f:
        plan = json.load(f)
        contracts = plan["contracts"]
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
    for row in contracts:
        if contract == int(row["contract"]):
            return float(row["price"])
    else:
        raise Exception("NotFoundContractError")


def calc_usage_rate(usages: dict, usage: int):

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


def calc_electric_simulations(contract=10, usage=10):

    simulations = []
    for profile in PROVIDER_DIR.glob("**/plan.json"):
        try:
            simulation = calc_plan(profile, contract, usage)
            simulations.append(simulation)
        except Exception as e:
            print(e)

    return simulations


if __name__ == "__main__":
    calc_electric_simulations()
