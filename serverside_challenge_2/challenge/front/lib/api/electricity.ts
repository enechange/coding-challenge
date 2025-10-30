import { ElectricityChargeRequest, ElectricityPlanResult } from "@/types/electricity";

export async function fetchElectricityCharges({
  ampere,
  usage,
}: ElectricityChargeRequest): Promise<ElectricityPlanResult[]> {
  const url = `${process.env.NEXT_PUBLIC_API_URL}/api/v1/electricity_charges?ampere=${ampere}&usage=${usage}`;
  const res = await fetch(url);
  const data = await res.json();

  if (!res.ok) {
    throw new Error(data.error || 'エラーが発生しました');
  }

  return data;
}
