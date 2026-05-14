// Rails 側 challenge/app/models/concerns/electricity_bill_constants.rb と二重管理
export const VALID_AMPERES = [10, 15, 20, 30, 40, 50, 60] as const;
export type ValidAmpere = (typeof VALID_AMPERES)[number];

export const MAX_KWH = 9999;

export const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL ?? "http://localhost:3000";
