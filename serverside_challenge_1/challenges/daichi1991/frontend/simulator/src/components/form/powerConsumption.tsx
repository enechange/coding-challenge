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
  const [errorMessage, setErrorMessage] = useState<string>('')
  const emptyKwh = useContext(ParametersContext).emptyKwh

  const hankakuToZenkaku = (input: string) => {
    return input.replace(/[Ａ-Ｚａ-ｚ０-９]/g, function (s) {
      return String.fromCharCode(s.charCodeAt(0) - 0xfee0)
    })
  }

  const handleKwh = (event: React.ChangeEvent<HTMLInputElement>) => {
    const inputValue = hankakuToZenkaku(event.target.value)
    const regex = new RegExp(/^[0-9]+$/)
    if (regex.test(inputValue) || inputValue === '') {
      setInputKwh(inputValue)
      handleSetKwh(Number(inputValue))
    }
    if (Number(inputValue) > 999999999) {
      setErrorMessage('999999999以下の数値で入力してください')
    } else {
      setErrorMessage('')
    }
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
          helperText="1以上の整数で入力"
        />
      </Box>
      <Typography color="red">{errorMessage}</Typography>
      <Typography color="red">{emptyKwh}</Typography>
    </>
  )
}
