from pydantic import BaseModel, field_validator
from .exception import (
    InvalidContractError,
    InvalidUsageError,
    InvalidContractsError,
    InvalidContractPriceError,
    InvalidUsageOverError,
    InvalidUsageUntilError,
    InvalidUsagePriceError,
)

NUM_OF_CONTRACTS = [10, 15, 20, 30, 40, 50, 60]


class PlanUsage(BaseModel):
    over: int
    until: int | float | None
    price: float

    @field_validator("over")
    def validate_over(cls, v: int):
        if v is None or v < 0:
            raise InvalidUsageOverError("Invalid over data")
        return v

    @field_validator("until")
    def validate_until(cls, v: int | float | None):

        if v is None:
            v = float("inf")

        if v < 0:
            raise InvalidUsageUntilError("Invalid until data")
        return v

    @field_validator("price")
    def validate_price(cls, v: float):
        if v is None or v < 0:
            raise InvalidUsagePriceError("Invalid price data")
        return v


class PlanContract(BaseModel):
    contract: int
    price: float

    @field_validator("contract")
    def validate_contract(cls, v: int):
        if v is None or v < 0:
            raise InvalidContractsError("Invalid contracts data")
        return v

    @field_validator("price")
    def validate_price(cls, v: float):
        if v is None or v < 0:
            raise InvalidContractPriceError("Invalid price data")
        return v


class ProFile(BaseModel):
    provider: str
    plan: str
    contracts: list[PlanContract]
    usage: list[PlanUsage]


class UserData(BaseModel):
    contract: int
    usage: int

    @field_validator("contract")
    def validate_contract(cls, v: int):
        if v <= 0 or v not in NUM_OF_CONTRACTS:
            raise InvalidContractError(f"Invalid number of contract: {v}")
        return v

    @field_validator("usage")
    def validate_usage(cls, v: int):
        if v < 0:
            raise InvalidUsageError(f"Invalid number of usage: {v}")
        return v
