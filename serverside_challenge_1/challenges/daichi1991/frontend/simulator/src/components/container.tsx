import React from 'react'
import { ParametersProvider } from '../context/parametersContext'
import { PlansProvider } from '../context/plansContests'
import { AllForms } from './allForm'

export const Container = () => {
  return (
    <>
      <ParametersProvider>
        <PlansProvider>
          <AllForms />
        </PlansProvider>
      </ParametersProvider>
    </>
  )
}
