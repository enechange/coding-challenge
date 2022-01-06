import { ISimulation } from "@/types";
import {
  isValidArea,
  isValidCompany,
  isValidPlan,
  isValidAmps,
  isValidPay,
  isValidEmail,
} from "@/util/validationUtil";

// ** 各入力フォームの活性状態を判定する関数 **//

// 支払金額
export function isEnabledPayInput(simulationData: ISimulation): boolean {
  return (
    isValidArea(simulationData.area) &&
    isValidCompany(simulationData.company) &&
    isValidPlan(simulationData.plan) &&
    isValidAmps(simulationData)
  );
}

// メールアドレス
export function isEnabledEmailInput(simulationData: ISimulation): boolean {
  return isEnabledPayInput(simulationData) && isValidPay(simulationData.pay);
}

// 送信ボタン
export function isEnabledSendButton(simulationData: ISimulation): boolean {
  return (
    isEnabledEmailInput(simulationData) && isValidEmail(simulationData.email)
  );
}
