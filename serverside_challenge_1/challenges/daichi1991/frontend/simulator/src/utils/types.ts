export type PlanType = {
  provider_name: string
  plan: string
  price: number
}

export type ParametersType = {
  ampere: number
  kwh: number
  emptyKwh: string
}

export type ParametersOperationType = {
  handleSetAmpere: (imputAmpere: number) => void
  handleSetKwh: (inputKwh: number) => void
  handleSetEmptyKwh: (inputMessage: string) => void
}

export type GetPlansType = {
  getPlans: (ampere: number, kwh: number) => void
}
