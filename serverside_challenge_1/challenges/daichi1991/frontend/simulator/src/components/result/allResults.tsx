import React, { useContext } from 'react'
import { PlansContext } from '../../context/plansContests'
import { ResultWrapper } from './resultWrapper'

export const AllResults = () => {
  const plans = useContext(PlansContext)
  return (
    <>
      {Object.keys(plans).length != 0 && (
        <div>
          <h3>シミュレーション結果</h3>
          {plans.map((plan, index) => (
            <ResultWrapper key={index} plan={plan} />
          ))}
        </div>
      )}
    </>
  )
}
