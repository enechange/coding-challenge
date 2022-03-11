import axios from 'axios'
import React, { createContext, useState } from 'react'
import { GetPlansType, PlanType } from '../utils/types'
import { plansUrl } from '../utils/urls'

export const PlansContext = createContext<PlanType[]>([])

const defaultGetPlans = {
  getPlans: () => console.error('Providerが設定されていません'),
}

export const GetPlansContext = createContext<GetPlansType>(defaultGetPlans)

export const PlansProvider: React.FC = (children) => {
  const [plans, setPlans] = useState<PlanType[]>([])

  const getPlans = (ampere: number, kwh: number) => {
    const sendPlansUrl = plansUrl + '?ampere=' + ampere + '&kwh=' + kwh
    axios
      .get(sendPlansUrl, {
        headers: {
          'Content-Type': 'application/json',
        },
        withCredentials: true,
      })
      .then((res) => {
        console.log('success')
        setPlans(res.data)
      })
  }

  return (
    <PlansContext.Provider value={plans}>
      <GetPlansContext.Provider value={{ getPlans }}>
        {children.children}
      </GetPlansContext.Provider>
    </PlansContext.Provider>
  )
}
