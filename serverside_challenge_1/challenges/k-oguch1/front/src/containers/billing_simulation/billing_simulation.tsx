"use client"

import {
  FormEventHandler,
  useState,
} from "react";

import { calculateBillings, isAmperageValue } from "@/api";

import { Badge } from "./badge"

type SimulationResult = SimulationResultEntry[]

type SimulationResultEntry = {
  providerName: string
  planName: string
  price: number
}

export const BillingSimulation = () => {
  const [result, setResult] = useState<SimulationResult|undefined>(undefined)

  const handleSubmit: FormEventHandler<HTMLFormElement> = async (ev) => {
    ev.preventDefault()

    const form = new FormData(ev.target as HTMLFormElement)
    const amperage = parseInt(form.get('amperage') as string)
    const usedKwh = parseInt(form.get('usedKwh') as string)

    if (!isAmperageValue(amperage)) {
      // 基本的にここには来ないはず
      return
    }

    const data = await calculateBillings(amperage, usedKwh)
    setResult(data)
  }

  return (
    <>
      <form onSubmit={handleSubmit} className="group">
        <div className="my-5">
          <label>
            <div className="mb-2">
              <Badge>必須</Badge>
              契約アンペア数
            </div>
            <select
              name="amperage"
              required
              className="peer text-lg"
            >
              <option value="" disabled>選択してください</option>
              <option value="10">10A</option>
              <option value="15">15A</option>
              <option value="20">20A</option>
              <option value="30">30A</option>
              <option value="40">40A</option>
              <option value="50">50A</option>
              <option value="60">60A</option>
            </select>
          </label>
        </div>

        <div className="my-5">
          <label className="group">
            <div className="mb-2">
              <Badge>必須</Badge>
              使用量
            </div>
            <input
              name="usedKwh"
              required
              type="text"
              pattern="[0-9]+"
              placeholder="入力してください"
              className="peer text-lg"
            />
            kWh
            <span className="text-red-500 hidden peer-[&:not(:placeholder-shown):invalid]:block">
              整数値で入力してください
            </span>
          </label>
        </div>

        <div className="mb-10">
          <button
            type="submit"
            className="group-invalid:pointer-events-none group-invalid:opacity-30 bg-blue-800 text-white p-3 rounded w-full"
          >
            計算
          </button>
        </div>
      </form>

      <div>
        {result && (
          <div>
            シミュレーション結果
            {result.map((r) => (
              <div className="m-2" key={`result-${r.providerName}-${r.planName}`}>
                <div>会社: {r.providerName}</div>
                <div>プラン名: {r.planName}</div>
                <div>価格: {r.price}円</div>
              </div>
            ))}
          </div>
        )}
      </div>
    </>
  )
}
