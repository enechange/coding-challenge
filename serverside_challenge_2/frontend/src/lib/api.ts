import { API_BASE_URL } from "@/lib/constants";
import type { SimulationResult, SimulationError } from "@/types/api";

export class ApiValidationError extends Error {
  constructor(public readonly errors: SimulationError["errors"]) {
    super(errors.map((e) => e.detail).join(", "));
    this.name = "ApiValidationError";
  }
}

type FetchSimulationsParams = {
  ampere: number;
  kwh: number;
  signal?: AbortSignal;
};

export async function fetchSimulations({
  ampere,
  kwh,
  signal,
}: FetchSimulationsParams): Promise<SimulationResult[]> {
  const url = new URL("/api/v1/electricity_bill_simulations", API_BASE_URL);
  url.searchParams.set("ampere", String(ampere));
  url.searchParams.set("kwh", String(kwh));

  const res = await fetch(url.toString(), { signal });

  if (res.status === 400) {
    const body: SimulationError = await res.json();
    throw new ApiValidationError(body.errors);
  }

  if (!res.ok) {
    throw new Error(`サーバーエラーが発生しました (${res.status})`);
  }

  const body: { data: SimulationResult[] } = await res.json();
  return body.data;
}
