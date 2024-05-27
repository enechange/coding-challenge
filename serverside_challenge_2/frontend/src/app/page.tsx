"use client";
import styles from "./page.module.css";
import axios from "axios";
import React, { useState } from "react";
import { useForm, SubmitHandler } from 'react-hook-form';
import {
  FormControl,
  FormLabel,
  Select,
  Button,
  NumberInput,
  NumberInputField,
  NumberInputStepper,
  NumberIncrementStepper,
  NumberDecrementStepper,
  Container,
  Box,
  Text,
  FormErrorMessage
} from '@chakra-ui/react'

interface Inputs {
  amperage: number;
  usage_kwh: number;
};

interface SimulationResult {
  provider_name: string;
  plan_name: string;
  total_amount: number | null;
  error_message?: string;
}

export default function Home() {
  const [simulationResult, setSimulationResult] = useState([] as any);

  const getElectricityRateSimulationApi = (amperage: number, usage_kwh: number) => {
    axios.get(`http://localhost:3000/api/electricity_rate_simulations?amperage=${amperage}&usage_kwh=${usage_kwh}`,
    ).then(function (response) { // handle success
      setSimulationResult(response.data);
    })
    .catch(function (error) { // handle error
    })
    .finally(function () { // always executed
    });
  }

  const {
    register,
    getValues,
    handleSubmit,
    watch,
    formState: { errors },
  } = useForm<Inputs>();

  const executeSimulation: SubmitHandler<Inputs> = (e) => {
    getElectricityRateSimulationApi(getValues("amperage"), getValues("usage_kwh"));
  };

  const usageKwhValidationRules = {
    required: "使用量は必須です",
    pattern: {
      value: /^\d+$/,
      message: "使用量は整数で入力してください"
    }
  };

  return (
    <div>
    <Container>
      <Box mt='10'>
        <p>契約アンペア数と1ヶ月の使用量を入力することで、</p>
        <p>プランごとの電気料金をシュミレーションすることができます。</p>
      </Box>
      <Box mt='10'>
        <form onSubmit={handleSubmit(executeSimulation)}>
          <FormControl >
            <FormLabel htmlFor='amperage'>契約アンペア数（単位: A）</FormLabel>
            <Select id='amperage' {...register("amperage")}>
              <option value={10}>10</option>
              <option value={15}>15</option>
              <option value={20}>20</option>
              <option value={30}>30</option>
              <option value={40}>40</option>
              <option value={50}>50</option>
              <option value={60}>60</option>
            </Select>
          </FormControl>
          <FormControl isInvalid={Boolean(errors.usage_kwh)}>
            <FormLabel htmlFor='usage_kwh' mt='5'>使用量（単位: kWh）</FormLabel>
            <NumberInput defaultValue={0} min={0}>
              <NumberInputField id='usage_kwh' {...register("usage_kwh", usageKwhValidationRules)} />
              <NumberInputStepper>
                <NumberIncrementStepper />
                <NumberDecrementStepper />
              </NumberInputStepper>
            </NumberInput>
            <FormErrorMessage>
              {errors.usage_kwh && <p>{errors.usage_kwh.message}</p>}
            </FormErrorMessage>
          </FormControl>
          <Button mt={5} colorScheme='teal' type='submit'>
            決定
          </Button>
        </form>
      </Box>

      <Box mt='10'>
        {
          simulationResult.map((result: SimulationResult, i: number) => {
            return (
              <Box key={i} mb='5'>
                <p>電力会社: {result.provider_name}</p>
                <p>プラン: {result.plan_name}</p>
                <p>料金: {result.total_amount != null ? `${result.total_amount}円` : '-'}</p>
                { result.error_message && <Text color='tomato'>※{result.error_message}</Text> }
              </Box>
            )
          })
        }
      </Box>
    </Container>
    </div>
  );
}
