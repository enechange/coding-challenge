"use client";

import { useRef, useState } from "react";
import { SimulationForm } from "@/components/simulation-form";
import { SimulationResult } from "@/components/simulation-result";
import { fetchSimulations, ApiValidationError } from "@/lib/api";
import type { SimulationFormValues } from "@/lib/schema";
import type { SimulationResult as SimulationResultType } from "@/types/api";

export default function Home() {
  const [results, setResults] = useState<SimulationResultType[] | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const abortRef = useRef<AbortController | null>(null);

  async function handleSubmit(values: SimulationFormValues) {
    abortRef.current?.abort();
    const controller = new AbortController();
    abortRef.current = controller;

    setLoading(true);
    setError(null);
    setResults(null);

    try {
      const data = await fetchSimulations({
        ampere: values.ampere,
        kwh: values.kwh,
        signal: controller.signal,
      });
      setResults(data);
    } catch (err) {
      if (err instanceof Error && err.name === "AbortError") return;
      if (err instanceof ApiValidationError) {
        setError(err.message);
      } else {
        setError("通信エラーが発生しました。しばらく経ってから再試行してください。");
      }
    } finally {
      if (abortRef.current === controller) setLoading(false);
    }
  }

  return (
    <main className="mx-auto max-w-xl w-full px-4 py-8 space-y-8">
      <h1 className="text-2xl font-bold text-center">電気料金シミュレーター</h1>
      <SimulationForm onSubmit={handleSubmit} isLoading={loading} />
      <SimulationResult results={results} loading={loading} error={error} />
    </main>
  );
}
