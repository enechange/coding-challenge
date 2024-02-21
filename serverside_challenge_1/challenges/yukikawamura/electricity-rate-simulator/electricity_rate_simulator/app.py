from fastapi import FastAPI, HTTPException
import uvicorn


from electricity_rate_simulator.core.electric_simurate import calc_electric_simurations

app = FastAPI()

contracts = [10, 15, 20, 30, 40, 50, 60]


@app.get("/")
def get_root():
    return {"app": "electricity-rate-simulator"}


@app.get("/simurations")
def electric_simurations_api(contract: int, usage: int):
    if not contract or not usage:
        raise HTTPException(status_code=404, detail=f"not found parameters: {contract} or {usage}")
    
    if contract not in contracts:
        raise HTTPException(status_code=404, detail=f"target contract is failed: {contract}")

    simurations = calc_electric_simurations(contract, usage)

    return simurations


if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=8000, reload=True)
