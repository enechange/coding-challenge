import { BillingApi, Configuration } from './generated'

const API_HOST = process.env.NEXT_PUBLIC_API_HOST

const conf = new Configuration({
  basePath: API_HOST,
})

const api = new BillingApi(conf)

const AmperageValues = [10, 15, 20, 30, 40, 50, 60] as const
export type AmperageValue = typeof AmperageValues[number]

export const isAmperageValue: (value: number) => value is AmperageValue = (value: number): value is AmperageValue => {
  return AmperageValues.includes(value as AmperageValue)
}

export const calculateBillings = async (amperage: AmperageValue, usedKwh: number) => {
  const data = await api.calculateBillings({
    calculateBillingsRequest: {
      amperage,
      usedKwh,
    }
  })

  return data
}
