import React, { FC } from 'react';
import { Table, TableBody, TableCell, TableContainer, TableHead, TableRow, Paper } from '@mui/material'
import { ElectricityRate } from '../App';

type Props = {
  electricityRates: ElectricityRate[]
}

export const ElectricityRateList: FC<Props> = ({
  electricityRates
}) => {
  return (
    <TableContainer component={Paper} sx={{ width: 600 }}>
      <Table aria-label="simple table">
        <TableHead>
          <TableRow>
            <TableCell>電力会社名</TableCell>
            <TableCell>プラン名</TableCell>
            <TableCell >金額</TableCell>
          </TableRow>
        </TableHead>
        <TableBody>
          {electricityRates.map((electricityRate) => (
            <TableRow
              key={electricityRate.providerName}
              sx={{ '&:last-child td, &:last-child th': { border: 0 } }}
            >
              <TableCell component="th" scope="row">
                {electricityRate.providerName}
              </TableCell>
              <TableCell>{electricityRate.planName}</TableCell>
              <TableCell>{electricityRate.price}円</TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    </TableContainer>
  );
}