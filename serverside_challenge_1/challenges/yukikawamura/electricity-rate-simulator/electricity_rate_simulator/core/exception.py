class ElectricSimulationError(Exception):
    pass


class ElectricSimulateProviderError(ElectricSimulationError):
    pass


class NotFoundProviderError(ElectricSimulateProviderError):
    pass


class InvalidContractsError(ElectricSimulateProviderError):
    pass


class InvalidUsagesError(ElectricSimulateProviderError):
    pass


class InvalidProviderError(ElectricSimulateProviderError):
    pass


class InvalidPlanError(ElectricSimulateProviderError):
    pass


class InvalidUsageOverError(InvalidUsagesError):
    pass


class InvalidUsagePriceError(InvalidUsagesError):
    pass


class ElectricSimulateClientError(ElectricSimulationError):
    pass


class InvalidContractError(ElectricSimulateClientError):
    pass


class NotFoundContractError(ElectricSimulateClientError):
    pass


class InvalidUsageError(ElectricSimulateClientError):
    pass
