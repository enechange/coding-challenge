import { Box, Typography } from '@mui/material'
import React, { useContext } from 'react'
import {
  PlanErrorMessageContext,
  PlansContext,
} from '../../context/plansContests'
import { AllResultsStyle } from '../../utils/styles'
import { ResultWrapper } from './resultWrapper'

export const AllResults = () => {
  const plans = useContext(PlansContext)
  const planErrorMessage = useContext(PlanErrorMessageContext)
  return (
    <>
      <Typography variant="h6" color="red">
        {planErrorMessage}
      </Typography>
      {Object.keys(plans).length != 0 && (
        <Box sx={AllResultsStyle}>
          <Typography variant="h6">シミュレーション結果</Typography>
          {plans.map((plan, index) => (
            <ResultWrapper key={index} plan={plan} index={index} />
          ))}
        </Box>
      )}
    </>
  )
}
