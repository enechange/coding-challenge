import uvicorn
from electricity_rate_simulator.core import ElectricSimulator
from electricity_rate_simulator.exception import (
    ElectricSimulateClientError,
    ElectricSimulationError,
)
from electricity_rate_simulator.model import UserData
from electricity_rate_simulator.utils import setup_logging
from fastapi import FastAPI, HTTPException
from pydantic import ValidationError

app = FastAPI()

lgr = setup_logging()


@app.get("/")
def get_root():
    return {"app": "electricity-rate-simulator"}


@app.get("/simulations")
def electric_simulations_api(contract: int, usage: int):

    try:
        user_data = UserData(contract=contract, usage=usage)
    except (ElectricSimulateClientError, ValidationError) as e:
        raise HTTPException(status_code=400, detail=f"{e}")

    try:
        electric_simulator = ElectricSimulator()
        return electric_simulator.simulate(user_data)
    except ElectricSimulationError as e:
        lgr.exception(e)
        raise HTTPException(status_code=500, detail=f"{e}")


if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
