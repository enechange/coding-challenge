from fastapi import FastAPI, HTTPException
import uvicorn
import logging

from electricity_rate_simulator.core.electric_simulate import ElectricSimulator
from electricity_rate_simulator.core.exception import ElectricSimulationError

app = FastAPI()

NUM_OF_CONTRACTS = [10, 15, 20, 30, 40, 50, 60]

lgr = logging.getLogger("uvicorn.app")
lgr.setLevel(logging.INFO)


@app.get("/")
def get_root():
    return {"app": "electricity-rate-simulator"}


@app.get("/simulations")
def electric_simulations_api(contract: int, usage: int):
    if not contract or contract not in NUM_OF_CONTRACTS:
        raise HTTPException(
            status_code=400, detail=f"Invailed value of contract: {contract}"
        )

    if usage < 0:
        raise HTTPException(status_code=400, detail=f"Invailed value of usage: {usage}")

    try:
        electric_simulator = ElectricSimulator()
        return electric_simulator.simulate(contract, usage)
    except ElectricSimulationError as e:
        lgr.exception(e)
        raise HTTPException(status_code=500, detail=f"{e}")


if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
