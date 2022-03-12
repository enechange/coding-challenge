import { Box } from '@mui/material'
import Card from '@mui/material/Card'
import Typography from '@mui/material/Typography'
import React from 'react'
import { PlanType } from '../../utils/types'

interface Props {
  plan: PlanType
  index: number
}

export const ResultWrapper = (props: Props) => {
  const planState = props.plan
  const indexNo = props.index
  return (
    <>
      <Card
        sx={{
          width: '100%',
          m: '0 auto',
          mt: 2,
          height: 120,
          border: 0.5,
          display: 'block',
          position: 'relative',
          animationName: 'fadeUpAnime',
          animationDuration: '0.5s',
          animationFillMode: 'forwards',
          opacity: 0,
        }}
      >
        {indexNo == 0 && <Typography variant="subtitle2">最もお得!</Typography>}
        <Box
          sx={{
            position: 'absolute',
            width: '100%',
            top: '50%',
            transform: 'translateY(-50%)',
            textAlign: 'center',
          }}
        >
          <Typography variant="h6" component="span" sx={{ fontWeight: 'bold' }}>
            {planState.plan}
          </Typography>
          <Typography variant="subtitle1" component="span" sx={{ ml: 2 }}>
            {planState.provider_name}
          </Typography>
          <Typography variant="h4" color={'red'}>
            <Typography variant="subtitle1" component="span">
              月
            </Typography>
            {planState.price.toLocaleString()}
            <Typography variant="subtitle1" component="span">
              円
            </Typography>
          </Typography>
        </Box>
      </Card>
    </>
  )
}
