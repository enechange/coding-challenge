import { MenuItem } from '@mui/material'
import Box from '@mui/material/Box'
import FormControl from '@mui/material/FormControl'
import InputLabel from '@mui/material/InputLabel'
import Select, { SelectChangeEvent } from '@mui/material/Select'
import React, { useState } from 'react'

export const AmpereForm = () => {
  const [ampere, setAmpere] = useState<string>('10')
  const handleChnage = (event: SelectChangeEvent) => {
    setAmpere(event.target.value as string)
  }
  return (
    <Box sx={{ minWidth: 120 }}>
      <FormControl
        sx={{
          '& > :not(style)': { m: 1, width: '25ch' },
        }}
      >
        <InputLabel id="ampere-select-label">契約アンペア数</InputLabel>
        <Select
          labelId="ampere-select-label"
          id="ampere-select"
          value={ampere}
          label="契約アンペア数"
          onChange={handleChnage}
          defaultValue={'10'}
        >
          <MenuItem value={'10'}>10</MenuItem>
          <MenuItem value={'20'}>20</MenuItem>
          <MenuItem value={'30'}>30</MenuItem>
          <MenuItem value={'40'}>40</MenuItem>
          <MenuItem value={'50'}>50</MenuItem>
          <MenuItem value={'60'}>60</MenuItem>
        </Select>
      </FormControl>
    </Box>
  )
}
