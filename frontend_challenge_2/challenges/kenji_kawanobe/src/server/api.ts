import { ISimulation, Simulation } from "@/types";

export function sendSimulationData(simulationData: ISimulation): void {
  // NOTE: 型を変換し値を出力
  const request: Simulation = {
    zipCode: simulationData.firstZipCode + simulationData.secondZipCode,
    company: simulationData.company,
    plan: simulationData.plan,
    amps: simulationData.amps,
    pay: Number(simulationData.pay),
    email: simulationData.email,
  };
  alert(
    `【結果を見る(入力値の確認)】\n郵便番号：${request.zipCode}\n会社：${request.company}\nプラン：${request.plan}\n契約容量：${request.amps}\n支払金額：${request.pay}\nメールアドレス：${request.email}`
  );
}
