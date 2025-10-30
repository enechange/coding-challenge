export interface ElectricityChargeRequest {
  ampere: number;
  usage: number;
}

export interface ElectricityPlanResult {
  provider_name: string;
  plan_name: string;
  price: number;
}
