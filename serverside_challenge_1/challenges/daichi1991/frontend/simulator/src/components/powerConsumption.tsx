import Box from '@mui/material/Box'
import TextField from '@mui/material/TextField'
import React, { useState } from 'react'

export const PowerConsumption = () => {
  const [kwh, setKwh] = useState<string>('')
  const handleKwh = (event: React.ChangeEvent<HTMLInputElement>) => {
    setKwh(event.target.value)
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
        value={kwh}
        onChange={handleKwh}
      />
    </Box>
  )
}
