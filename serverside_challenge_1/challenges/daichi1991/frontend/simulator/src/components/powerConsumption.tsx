import Box from '@mui/material/Box'
import TextField from '@mui/material/TextField'
import React, { useContext, useState } from 'react'
import { ParametersOperationContext } from '../context/parametersContext'

export const PowerConsumption = () => {
  const handleSetKwh = useContext(ParametersOperationContext).handleSetKwh
  const [inputkwh, setInputKwh] = useState<string>('')
  const handleKwh = (event: React.ChangeEvent<HTMLInputElement>) => {
    setInputKwh(event.target.value)
    handleSetKwh(Number(event.target.value))
  }
  return (
    <Box
      component="form"
      sx={{
        '& > :not(style)': { m: 1, width: '25ch' },
      }}
      noValidate
      autoComplete="off"
    >
      <TextField
        id="outlined-basic"
        label="電力使用量"
        variant="outlined"
        value={inputkwh}
        onChange={handleKwh}
      />
    </Box>
  )
}
