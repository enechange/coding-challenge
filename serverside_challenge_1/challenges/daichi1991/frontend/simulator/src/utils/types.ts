export type PlanType = {
  provider_name: string
  plan: string
  price: number
}

export type ParametersType = {
  ampere: number
  kwh: number
}

export type ParametersOperationType = {
  handleSetAmpere: (imputAmpere: number) => void
  handleSetKwh: (inputKwh: number) => void
}

export type GetPlansType = {
  getPlans: (ampere: number, kwh: number) => void
}
