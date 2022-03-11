import Button from '@mui/material/Button'
import React, { useContext } from 'react'
import { ParametersContext } from '../../context/parametersContext'
import { GetPlansContext } from '../../context/plansContests'

export const SendButton = () => {
  const getPlans = useContext(GetPlansContext).getPlans
  const ampere = useContext(ParametersContext).ampere
  const kwh = useContext(ParametersContext).kwh

  const handleGetPlans = () => {
    console.log(kwh)
    getPlans(ampere, kwh)
  }

  return (
    <>
      <Button variant="contained" onClick={handleGetPlans}>
        シミュレーションする
      </Button>
    </>
  )
}
