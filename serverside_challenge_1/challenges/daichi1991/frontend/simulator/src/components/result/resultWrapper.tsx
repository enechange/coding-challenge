import React from 'react'
import { PlanType } from '../../utils/types'

interface Props {
  plan: PlanType
}

export const ResultWrapper = (props: Props) => {
  const planState = props.plan
  return (
    <>
      <p>{planState.provider_name}</p>
      <p>{planState.plan}</p>
      <p>{planState.price}</p>
    </>
  )
}
