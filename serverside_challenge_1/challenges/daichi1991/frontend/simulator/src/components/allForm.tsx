import React from 'react'
import { AmpereForm } from './ampereForm'
import { PowerConsumption } from './powerConsumption'
import { SendButton } from './sendButton'

export const AllForms = () => {
  return (
    <>
      <AmpereForm />
      <PowerConsumption />
      <SendButton />
    </>
  )
}
