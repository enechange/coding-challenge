import React, { createContext, useState } from 'react'
import { ParametersOperationType, ParametersType } from '../utils/types'

const defaultParameters = {
  ampere: 0,
  kwh: 0,
  emptyKwh: '',
}

export const ParametersContext =
  createContext<ParametersType>(defaultParameters)

const defaultParametersOperation = {
  handleSetAmpere: () => console.error('Providerが設定されていません'),
  handleSetKwh: () => console.error('Providerが設定されていません'),
  handleSetEmptyKwh: () => console.error('Providerが設定されていません'),
}

export const ParametersOperationContext =
  createContext<ParametersOperationType>(defaultParametersOperation)

export const ParametersProvider: React.FC = (children) => {
  const [ampere, setAmpere] = useState<number>(10)
  const [kwh, setKwh] = useState<number>(0)
  const [emptyKwh, setEmptyKwh] = useState<string>('')

  const handleSetAmpere = (imputAmpere: number) => {
    setAmpere(imputAmpere)
  }

  const handleSetKwh = (inputKwh: number) => {
    setKwh(inputKwh)
  }

  const handleSetEmptyKwh = (inputMessage: string) => {
    setEmptyKwh(inputMessage)
  }

  return (
    <ParametersContext.Provider value={{ ampere, kwh, emptyKwh }}>
      <ParametersOperationContext.Provider
        value={{ handleSetAmpere, handleSetKwh, handleSetEmptyKwh }}
      >
        {children.children}
      </ParametersOperationContext.Provider>
    </ParametersContext.Provider>
  )
}
