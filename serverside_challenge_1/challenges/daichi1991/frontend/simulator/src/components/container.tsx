import React from 'react'
import { ParametersProvider } from '../context/parametersContext'
import { PlansProvider } from '../context/plansContests'
import { AllForms } from './form/allForms'
import { Header } from './header'
import { AllResults } from './result/allResults'

export const Container = () => {
  return (
    <>
      <ParametersProvider>
        <PlansProvider>
          <Header />
          <AllForms />
          <AllResults />
        </PlansProvider>
      </ParametersProvider>
    </>
  )
}
