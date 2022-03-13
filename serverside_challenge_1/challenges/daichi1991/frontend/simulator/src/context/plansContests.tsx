import axios from 'axios'
import React, { createContext, useState } from 'react'
import { GetPlansType, PlanType } from '../utils/types'
import { plansUrl } from '../utils/urls'

export const PlansContext = createContext<PlanType[]>([])

const defaultGetPlans = {
  getPlans: () => console.error('Providerが設定されていません'),
}

export const GetPlansContext = createContext<GetPlansType>(defaultGetPlans)

export const PlanErrorMessageContext = createContext<string>('')

export const PlansProvider: React.FC = (children) => {
  const [plans, setPlans] = useState<PlanType[]>([])
  const [planErrorMessage, setPlanErrorMessage] = useState<string>('')

  const getPlans = (ampere: number, kwh: number) => {
    const sendPlansUrl = plansUrl + '?ampere=' + ampere + '&kwh=' + kwh
    axios
      .get(sendPlansUrl, {
        headers: {
          'Content-Type': 'application/json',
        },
      })
      .then((res) => {
        setPlanErrorMessage('')
        setPlans(res.data)
      })
      .catch(() => {
        setPlans([])
        setPlanErrorMessage('入力値が不正です。')
      })
  }

  return (
    <PlansContext.Provider value={plans}>
      <GetPlansContext.Provider value={{ getPlans }}>
        <PlanErrorMessageContext.Provider value={planErrorMessage}>
          {children.children}
        </PlanErrorMessageContext.Provider>
      </GetPlansContext.Provider>
    </PlansContext.Provider>
  )
}
