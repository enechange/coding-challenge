from fastapi import FastAPI, HTTPException
import uvicorn
import logging

from electricity_rate_simulator.core.electric_simulate import ElectricSimulator
from electricity_rate_simulator.exception import ElectricSimulationError
from electricity_rate_simulator.model import UserData

NUM_OF_CONTRACTS = [10, 15, 20, 30, 40, 50, 60]

app = FastAPI()

lgr = logging.getLogger("uvicorn.app")
lgr.setLevel(logging.INFO)


@app.get("/")
def get_root():
    return {"app": "electricity-rate-simulator"}


@app.get("/simulations")
def electric_simulations_api(contract: int, usage: int):
    
    try:
        user_data = UserData(contract=contract, usage=usage)
    except ElectricSimulationError as e:
        raise HTTPException(
                status_code=400, detail=f"{e}"
            )

    try:
        electric_simulator = ElectricSimulator()
        return electric_simulator.simulate(user_data)
    except ElectricSimulationError as e:
        lgr.exception(e)
        raise HTTPException(status_code=500, detail=f"{e}")


if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
