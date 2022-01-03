import { areaTypes, ISimulation, Simulation } from "@/types";
import { isValidZipCode } from "@/util/validationUtil";

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

export function areaCheck(
  firstZipCode: string,
  secondZipCode: string
): areaTypes {
  const areaType = areaCheckAPI(firstZipCode, secondZipCode);
  return areaType;
}

// TODO: 後にサーバサイドのAPIを利用してエリアを判定する
function areaCheckAPI(firstZipCode: string, secondZipCode: string): areaTypes {
  if (!isValidZipCode(firstZipCode, secondZipCode)) {
    return areaTypes.OTHER;
  } else if (firstZipCode.slice(0, 1) === "1") {
    return areaTypes.TOKYO;
  } else if (firstZipCode.slice(0, 1) === "5") {
    return areaTypes.KANSAI;
  } else {
    return areaTypes.OTHER;
  }
}
