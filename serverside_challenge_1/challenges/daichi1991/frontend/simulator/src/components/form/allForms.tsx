import { Box } from '@mui/material'
import React from 'react'
import { AllFormsStyle } from '../../utils/styles'
import { AmpereForm } from './ampereForm'
import { PowerConsumption } from './powerConsumption'
import { SendButton } from './sendButton'

export const AllForms = () => {
  return (
    <>
      <Box sx={AllFormsStyle}>
        <AmpereForm />
        <PowerConsumption />
        <SendButton />
      </Box>
    </>
  )
}
