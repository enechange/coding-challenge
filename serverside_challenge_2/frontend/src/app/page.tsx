"use client";
import styles from "./page.module.css";
import axios from "axios";
import React, { useState } from "react";
import { useForm, SubmitHandler } from 'react-hook-form';

interface Inputs {
  amperage: number;
  usage_kwh: number;
};

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

  return (
    <main className={styles.main}>
      <div>
        <form onSubmit={handleSubmit(executeSimulation)}>
          <div>
            <label>
              契約アンペア数:
              <select {...register("amperage")}>
                <option value={10}>10</option>
                <option value={15}>15</option>
                <option value={20}>20</option>
                <option value={30}>30</option>
                <option value={40}>40</option>
                <option value={50}>50</option>
                <option value={60}>60</option>
              </select>A
            </label>
          </div>
          <div>
            <label>
              使用量:
              <input type="number" {...register("usage_kwh")} />kWh
            </label>
          </div>

          <button type="submit">送信</button>
        </form>
        </div>

        {
          simulationResult.map((result: any, i: any) => {
            return (
              <div key={i}>
                <p>電力会社: {result.provider_name}</p>
                <p>プラン: {result.provider_name}</p>
                <p>料金: {result.total_amount != null ? result.total_amount : '-'}</p>
              </div>
            )
          })
        }
        <div>
      </div>
    </main>
  );
}
