import { Box } from '@mui/material'
import React from 'react'
import { AmpereForm } from './ampereForm'
import { PowerConsumption } from './powerConsumption'
import { SendButton } from './sendButton'

export const AllForms = () => {
  return (
    <>
      <Box
        sx={{
          width: '80%',
          margin: '0 auto',
          mt: 2,
          padding: 2,
          border: 0.5,
          borderRadius: '5px',
        }}
      >
        <AmpereForm />
        <PowerConsumption />
        <SendButton />
      </Box>
    </>
  )
}
