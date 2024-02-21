from pathlib import Path
import csv

BASE_DIR = Path(
    "/workspaces/coding-challenge/serverside_challenge_1/challenges/yukikawamura/electricity-rate-simulator/electricity_rate_simulator"
)
DATA_DIR = BASE_DIR.joinpath("data")
TEPCO_DIR = DATA_DIR.joinpath("plovider", "tepco", "plan.csv")
LOOOP_DIR = DATA_DIR.joinpath("plovider", "looop", "plan.csv")
JXTG_DIR = DATA_DIR.joinpath("plovider", "jxtg-electric", "plan.csv")
TOKYOGAS_DIR = DATA_DIR.joinpath("plovider", "tokyo-gas", "plan.csv")


def calc_usage_rate_by_tepco(amount: int):
    """電気料金計算

    e.g.)
    最初の120kWhまで(第1段階料金)	1kWh	30円00銭
    120kWhをこえ300kWhまで(第2段階料金)	〃	36円60銭
    上記超過(第3段階料金)	〃	40円69銭

    Args:
        amount (_type_): _description_

    """
    if not amount:
        raise ValueError(f"AmountValueError: {amount}")

    if amount <= 120:
        return amount * 30.00
    elif amount <= 300:
        over_amount = amount - 120
        return 120 * 30.00 + over_amount * 36.60
    else:
        over_amount = amount - 300
        return 120 * 30.00 + 180 * 36.60 + over_amount * 40.69


def calc_usage_rate_by_looop(amount: int):
    if not amount:
        raise ValueError(f"AmountValueError: {amount}")

    return amount * 26.40


def calc_usage_rate_by_tokyo_gas(amount: int):
    if not amount:
        raise ValueError(f"AmountValueError: {amount}")

    if amount <= 140:
        return amount * 33.79
    elif amount <= 350:
        over_amount = amount - 140
        return 140 * 33.79 + over_amount * 34.00
    else:
        over_amount = amount - 350
        return 140 * 33.79 + 210 * 34.00 + over_amount * 36.53


def calc_usage_rate_by_jxtg_electrictiy(amount: int):
    if not amount:
        raise ValueError(f"AmountValueError: {amount}")

    if amount <= 120:
        return amount * 19.88
    elif amount <= 300:
        over_amount = amount - 120
        return 120 * 19.88 + over_amount * 26.48
    elif amount <= 600:
        over_amount = amount - 300
        return 120 * 19.88 + 180 * 19.88 + over_amount * 25.08
    else:
        over_amount = amount - 600
        return 120 * 33.79 + 180 * 34.00 + 300 * 25.08 + over_amount * 26.15


def _select_base_rate(plan_data: Path, ampare: int):
    with open(plan_data, "r") as f:
        reader = csv.DictReader(f)

        for row in reader:

            if ampare == int(row["contract"]):
                return float(row["price"])
        
        else:
            raise Exception("NotFoundContractError")


def base_rate_by_tepco(ampare: int):
    return _select_base_rate(TEPCO_DIR, ampare)


def base_rate_by_looop(ampare: int):
    return _select_base_rate(LOOOP_DIR, ampare)


def base_rate_by_tokyo_gas(ampare: int):
    return _select_base_rate(TOKYOGAS_DIR, ampare)


def base_rate_by_jxtg_electricity(ampare: int):
    return _select_base_rate(JXTG_DIR, ampare)


def calc_electric_simurations(contract=10, amount=10):

    simulations = []

    try:
        base_price_by_tempco = base_rate_by_tepco(contract)
        usage_price_by_tempco = calc_usage_rate_by_tepco(amount)
        total_price_by_tempco = base_price_by_tempco + usage_price_by_tempco
        simulation = {
            "provider": "東京電力エナジーパートナー",
            "plan": "従量電灯B",
            "price": f"{total_price_by_tempco}",
        }
        simulations.append(simulation)
    except Exception as e:
        print(e)

    try:
        base_price_by_looop = base_rate_by_looop(contract)
        usage_price_by_looop = calc_usage_rate_by_looop(amount)
        total_price_by_looop = base_price_by_looop + usage_price_by_looop
        simulation = {
            "provider": "Loopでんき",
            "plan": "おうちプラン",
            "price": f"{total_price_by_looop}",
        }
        simulations.append(simulation)
    except Exception as e:
        print(e)

    try:
        base_price_by_tokyo_gas = base_rate_by_tokyo_gas(contract)
        usage_price_by_tokyo_gas = calc_usage_rate_by_tokyo_gas(amount)
        total_price_by_tokyo_gas = base_price_by_tokyo_gas + usage_price_by_tokyo_gas
        simulation = {
            "provider": "東京ガス ",
            "plan": "ずっとも電気1",
            "price": f"{total_price_by_tokyo_gas}",
        }
        simulations.append(simulation)
    except Exception as e:
        print(e)

    try:
        base_price_by_jxtg_electricity = base_rate_by_jxtg_electricity(contract)
        usage_price_by_jxtg_electricity = calc_usage_rate_by_jxtg_electrictiy(amount)
        total_price_by_jxtg_electricity = (
            base_price_by_jxtg_electricity + usage_price_by_jxtg_electricity
        )
        simulation = {
            "provider": "JXTGでんき",
            "plan": "従量電灯Bたっぷりプラン",
            "price": f"{total_price_by_jxtg_electricity}",
        }
        simulations.append(simulation)
    except Exception as e:
        print(e)
        
    if not simulations:
        raise Exception("NotFoundPlansError.")

    return simulations


if __name__ == "__main__":
    calc_electric_simurations()
