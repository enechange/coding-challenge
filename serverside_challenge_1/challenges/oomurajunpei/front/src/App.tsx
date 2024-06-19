import React, { useState } from 'react';
import { useForm, Controller, SubmitHandler } from 'react-hook-form';
import { InputLabel, TextField, MenuItem, Button, Select, FormHelperText, FormControl, Stack } from '@mui/material';
import { getElectricityRateSimulation } from './client';
import { ElectricityRateList } from './components/ElectricityRateList';

type FormProps = {
  ampere: number;
  electricityUsage: string;
};

export type ElectricityRate = {
  providerName: string;
  planName: string;
  price: number;
}

function App() {
  const {
    handleSubmit,
    control,
    formState: { isValid }
  } = useForm<FormProps>({
    mode: 'onChange',
    criteriaMode: 'all',
  });

  const [electricityRates, setElectricityRates] = useState<ElectricityRate[]>()
  const [isSubmitting, setIsSubmitting] = useState<boolean>(false)

  const validationRules = {
    electricityUsage: {
      validate: (value: string | '') => {
        if (value === '') {
          return '必須項目です'
        } else if (Math.sign(Number(value)) === -1 || !Number.isInteger(Number(value))) {
          return '0以上の整数でご入力ください'
        }
      }
    }
  }

  const onSubmit: SubmitHandler<FormProps>  = async (props) => {
    try {
      setIsSubmitting(true)
      const res = await getElectricityRateSimulation(props)
      setElectricityRates(res.data)
    } catch (e) {
      console.log(e)
    } finally {
      setIsSubmitting(false)
    }
  }

  return (
    <Stack
      my={7}
      mx={30}
      spacing={7}
      justifyContent='center'
      alignItems='center'
    >
      <h2>電気料金比較シミュレーション</h2>
      <Stack
        width={500}
        component='form'
        spacing={8}
        onSubmit={handleSubmit(onSubmit)}
      >
        <Controller
          name='ampere'
          control={control}
          rules={{
            required: '必須項目です'
          }}
          render={({ field, fieldState })=> (
            <FormControl fullWidth error={fieldState.invalid}>
              <InputLabel id='demo-simple-select-label'>契約アンペア数(単位A)</InputLabel>
              <Select
                labelId='demo-simple-select-label'
                id='demo-simple-select'
                label='契約アンペア数(単位A)'
                fullWidth
                required
                {...field}
              >
                <MenuItem value={10}>10</MenuItem>
                <MenuItem value={15}>15</MenuItem>
                <MenuItem value={20}>20</MenuItem>
                <MenuItem value={30}>30</MenuItem>
                <MenuItem value={40}>40</MenuItem>
                <MenuItem value={50}>50</MenuItem>
                <MenuItem value={60}>60</MenuItem>
              </Select>
              <FormHelperText>{fieldState.error?.message}</FormHelperText>
            </FormControl>
          )}
        />
        <Controller
          name='electricityUsage'
          control={control}
          rules={validationRules.electricityUsage}
          render={({ field, fieldState }) => (
            <TextField
              id='outlined-basic'
              label='電力使用量(単位kWh)'
              variant='outlined'
              fullWidth
              required
              error={fieldState.invalid}
              helperText={fieldState.error?.message}
              inputProps={{
                inputMode: "numeric",
                pattern: "[0-9]*"
              }}
              {...field}
            />
          )}
        />
        <Button
          variant='contained'
          type='submit'
          disabled={!isValid || isSubmitting}
        >
          シミュレーション
        </Button>
      </Stack>
      {electricityRates && (
        <ElectricityRateList electricityRates={electricityRates} />
      )}
    </Stack>
  );
}

export default App;
