import { ISimulation, areaTypes, companyTypes, planTypes } from "@/types";

// 郵便番号のバリデーション
export function isValidZipCode(
  firstZipCode: string,
  secondZipCode: string
): boolean {
  return /^[0-9]{3}$/.test(firstZipCode) && /^[0-9]{4}$/.test(secondZipCode);
}

export function isValidArea(area: areaTypes): boolean {
  return area !== areaTypes.OTHER && area !== areaTypes.UNSELECTED;
}

// 会社のバリデーション
export function isValidCompany(company: companyTypes): boolean {
  return (
    company !== companyTypes.UNSELECTED &&
    company !== companyTypes.OTHER &&
    Object.values(companyTypes).includes(company)
  );
}

// プランのバリデーション
export function isValidPlan(plan: planTypes): boolean {
  return (
    plan !== planTypes.UNSELECTED && Object.values(planTypes).includes(plan)
  );
}

// 契約容量のバリデーション
export function isValidAmps(simulationData: ISimulation): boolean {
  // NOTE: 関西電力 かつ 従量電灯A の場合は契約容量を聴取しない
  if (
    simulationData.company === companyTypes.KANSAI_DENRYOKU &&
    simulationData.plan === planTypes.PLAN_A
  ) {
    return true;
  }
  return !!simulationData.amps;
}

// 支払金額のバリデーション
const MIN_PAY = 1000;
export function isValidPay(pay: string | number): boolean {
  return (
    (typeof pay === "string" &&
      /^[0-9]+$/.test(pay) &&
      Number(pay) >= MIN_PAY) ||
    (typeof pay === "number" && pay >= MIN_PAY)
  );
}

// メールアドレスのバリデーション
// 出典
// https://emailregex.com/
// http://doshiroutonike.com/web/javascript-web/3222
const emailRegex =
  /^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/i;
export function isValidEmail(email: string): boolean {
  // NOTE: 英数記号以外の文字（全角文字）をふくまない かつ RFC規定のメールアドレス
  return !/[^!-~]/g.test(email) && emailRegex.test(email);
}
