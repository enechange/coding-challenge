import { Typography } from '@mui/material'
import AppBar from '@mui/material/AppBar'
import React from 'react'

export const Header = () => {
  return (
    <AppBar position="static">
      <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
        電気料金シミュレーター
      </Typography>
    </AppBar>
  )
}
