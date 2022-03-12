import { Box, Typography } from '@mui/material'
import React, { useContext } from 'react'
import { PlansContext } from '../../context/plansContests'
import { ResultWrapper } from './resultWrapper'

export const AllResults = () => {
  const plans = useContext(PlansContext)
  return (
    <>
      {Object.keys(plans).length != 0 && (
        <Box sx={{ width: '90%', margin: '0 auto', mt: 2, mb: 2 }}>
          <Typography variant="h6">シミュレーション結果</Typography>
          {plans.map((plan, index) => (
            <ResultWrapper key={index} plan={plan} index={index} />
          ))}
        </Box>
      )}
    </>
  )
}
