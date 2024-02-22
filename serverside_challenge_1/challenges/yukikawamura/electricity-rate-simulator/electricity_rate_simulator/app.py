from fastapi import FastAPI, HTTPException
import uvicorn


from electricity_rate_simulator.core.electric_simulate import calc_electric_simulations

app = FastAPI()

NUM_OF_CONTRACTS = [10, 15, 20, 30, 40, 50, 60]


@app.get("/")
def get_root():
    return {"app": "electricity-rate-simulator"}


@app.get("/simulations")
def electric_simulations_api(contract: int, usage: int):
    if not contract or not usage:
        raise HTTPException(status_code=404, detail=f"not found parameters: {contract} or {usage}")
    
    if contract not in NUM_OF_CONTRACTS:
        raise HTTPException(status_code=404, detail=f"target contract is failed: {contract}")

    try:
        simulations = calc_electric_simulations(contract, usage)
        return simulations
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"{e}")

    return simulations


if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
