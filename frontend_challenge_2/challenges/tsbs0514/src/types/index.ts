export type PowerArea = "tokyo" | "kansai" | "out-of-service";

import { z } from "zod";
import {
  powerCompanySchema,
  electricPlanSchema,
  contractCapacitySchema,
} from "@/schemas";

export type PowerCompany = z.infer<typeof powerCompanySchema>;

export type ElectricPlan = z.infer<typeof electricPlanSchema>;

export type ContractCapacity = z.infer<typeof contractCapacitySchema>;

export interface PlanOption {
  value: ElectricPlan;
  label: string;
  description: string;
}

export interface AreaCheckResponse {
  area: PowerArea;
  isValid: boolean;
  message?: string;
}

export interface CompanyCheckResponse {
  isValid: boolean;
  message?: string;
}
