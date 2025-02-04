class ElectricSimulationError(Exception):
    pass


class ElectricSimulateProviderError(ElectricSimulationError):
    pass


class NotFoundProviderError(ElectricSimulateProviderError):
    pass


class InvalidContractsError(ElectricSimulateProviderError):
    pass


class InvalidContractPriceError(ElectricSimulateProviderError):
    pass


class InvalidUsagesError(ElectricSimulateProviderError):
    pass


class InvalidUsageOverError(InvalidUsagesError):
    pass


class InvalidUsageUntilError(InvalidUsagesError):
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
