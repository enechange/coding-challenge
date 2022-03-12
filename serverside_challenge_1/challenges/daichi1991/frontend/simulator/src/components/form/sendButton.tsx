import Button from '@mui/material/Button'
import React, { useContext } from 'react'
import {
  ParametersContext,
  ParametersOperationContext,
} from '../../context/parametersContext'
import { GetPlansContext } from '../../context/plansContests'

export const SendButton = () => {
  const getPlans = useContext(GetPlansContext).getPlans
  const ampere = useContext(ParametersContext).ampere
  const kwh = useContext(ParametersContext).kwh
  const handleSetEmptyKwh = useContext(
    ParametersOperationContext,
  ).handleSetEmptyKwh

  const handleGetPlans = () => {
    getPlans(ampere, kwh)
    const EmptyMessage = kwh == 0 ? '1以上の値を入力してください' : ''
    handleSetEmptyKwh(EmptyMessage)
  }

  return (
    <>
      <Button variant="contained" onClick={handleGetPlans} sx={{ mt: 2 }}>
        シミュレーションする
      </Button>
    </>
  )
}
