import { Typography } from '@mui/material'
import Box from '@mui/material/Box'
import InputAdornment from '@mui/material/InputAdornment'
import InputLabel from '@mui/material/InputLabel'
import TextField from '@mui/material/TextField'
import React, { useContext, useState } from 'react'
import {
  ParametersContext,
  ParametersOperationContext,
} from '../../context/parametersContext'
import { FormStyle, InputTextStyle } from '../../utils/styles'

export const PowerConsumption = () => {
  const handleSetKwh = useContext(ParametersOperationContext).handleSetKwh
  const [inputkwh, setInputKwh] = useState<string>('')
  const emptyKwh = useContext(ParametersContext).emptyKwh

  const handleKwh = (event: React.ChangeEvent<HTMLInputElement>) => {
    const inputValue = event.target.value
    setInputKwh(inputValue)
    handleSetKwh(Number(inputValue))
  }
  return (
    <>
      <Box sx={FormStyle}>
        <InputLabel id="kwh-input-label">電気使用量</InputLabel>
        <TextField
          id="kwh-input"
          variant="outlined"
          value={inputkwh}
          onChange={handleKwh}
          sx={InputTextStyle}
          InputProps={{
            endAdornment: <InputAdornment position="end">kWh</InputAdornment>,
          }}
        />
      </Box>
      <Typography color="red">{emptyKwh}</Typography>
    </>
  )
}
