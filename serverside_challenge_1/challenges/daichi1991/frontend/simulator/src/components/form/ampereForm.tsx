import { MenuItem } from '@mui/material'
import Box from '@mui/material/Box'
import InputLabel from '@mui/material/InputLabel'
import Select, { SelectChangeEvent } from '@mui/material/Select'
import React, { useContext, useState } from 'react'
import { ParametersOperationContext } from '../../context/parametersContext'

export const AmpereForm = () => {
  const handleSetAmpere = useContext(ParametersOperationContext).handleSetAmpere

  const [imputAmpere, setImputAmpere] = useState<string>('10')

  const handleChnage = (event: SelectChangeEvent) => {
    setImputAmpere(event.target.value as string)
    handleSetAmpere(Number(event.target.value))
  }
  return (
    <Box sx={{ width: 160, margin: '0 auto', mb: 4 }}>
      <InputLabel id="ampere-select-label">契約アンペア数</InputLabel>
      <Select
        labelId="ampere-select-label"
        id="ampere-select"
        value={imputAmpere}
        label="ampere"
        onChange={handleChnage}
        defaultValue={'10'}
        sx={{ width: '100%', textAlign: 'left' }}
      >
        <MenuItem value={'10'}>10 A</MenuItem>
        <MenuItem value={'20'}>20 A</MenuItem>
        <MenuItem value={'30'}>30 A</MenuItem>
        <MenuItem value={'40'}>40 A</MenuItem>
        <MenuItem value={'50'}>50 A</MenuItem>
        <MenuItem value={'60'}>60 A</MenuItem>
      </Select>
    </Box>
  )
}
