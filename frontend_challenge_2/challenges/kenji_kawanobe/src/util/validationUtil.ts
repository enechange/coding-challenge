import { ISimulation, companyTypes, planTypes } from "@/types";

export function isValidZipCode(
  firstZipCode: string,
  secondZipCode: string
): boolean {
  return (
    !isNaN(Number(firstZipCode)) &&
    !isNaN(Number(secondZipCode)) &&
    firstZipCode.length === 3 &&
    (firstZipCode.slice(0, 1) === "1" || firstZipCode.slice(0, 1) === "5") &&
    secondZipCode.length === 4
  );
}

export function isValidCompany(company: companyTypes): boolean {
  return (
    company !== companyTypes.UNSELECTED &&
    company !== companyTypes.OTHER &&
    Object.values(companyTypes).includes(company)
  );
}

export function isValidPlan(plan: planTypes): boolean {
  return (
    plan !== planTypes.UNSELECTED && Object.values(planTypes).includes(plan)
  );
}

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

const MIN_PAY = 1000;
export function isValidPay(pay: string | number): boolean {
  return (
    (typeof pay === "string" &&
      !isNaN(Number(pay)) &&
      Number(pay) >= MIN_PAY) ||
    (typeof pay === "number" && pay >= MIN_PAY)
  );
}
