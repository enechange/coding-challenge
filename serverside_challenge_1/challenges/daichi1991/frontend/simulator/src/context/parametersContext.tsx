import React, { createContext, useState } from 'react'
import { ParametersOperationType, ParametersType } from '../utils/types'

const defaultParameters = {
  ampere: 0,
  kwh: 0,
}

export const ParametersContext =
  createContext<ParametersType>(defaultParameters)

const defaultParametersOperation = {
  handleSetAmpere: () => console.error('Providerが設定されていません'),
  handleSetKwh: () => console.error('Providerが設定されていません'),
}

export const ParametersOperationContext =
  createContext<ParametersOperationType>(defaultParametersOperation)

export const ParametersProvider: React.FC = (children) => {
  const [ampere, setAmpere] = useState<number>(10)
  const [kwh, setKwh] = useState<number>(0)

  const handleSetAmpere = (imputAmpere: number) => {
    setAmpere(imputAmpere)
  }

  const handleSetKwh = (inputKwh: number) => {
    setKwh(inputKwh)
  }

  return (
    <ParametersContext.Provider value={{ ampere, kwh }}>
      <ParametersOperationContext.Provider
        value={{ handleSetAmpere, handleSetKwh }}
      >
        {children.children}
      </ParametersOperationContext.Provider>
    </ParametersContext.Provider>
  )
}
