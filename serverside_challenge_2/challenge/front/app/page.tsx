"use client";

import { useState } from "react";
import { fetchElectricityCharges } from "@/lib/api/electricity";
import { ElectricityPlanResult } from "@/types/electricity";
import { ElectricityForm } from "@/components/ElectricityForm";
import { ResultCard } from "@/components/ResultCard";

export default function Home() {
  const [results, setResults] = useState<ElectricityPlanResult[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const handleCalculate = async (ampere: number, usage: number) => {
    setError(null);
    setResults([]);
    setLoading(true);

    try {
      const data = await fetchElectricityCharges({ ampere, usage });
      setResults(data);
    } catch (err: any) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="min-h-screen bg-gray-100 py-10 px-4">
      <div className="max-w-6xl mx-auto bg-white rounded-2xl shadow p-6 md:p-8">
        <h1 className="text-3xl font-bold mb-8 text-gray-800 text-center">
          電気料金計算ツール
        </h1>

        <div className="flex flex-col md:flex-row gap-8">
          <div className="md:w-1/3 w-full">
            <ElectricityForm onCalculate={handleCalculate} loading={loading} />
          </div>

          <div className="flex-1">
            {error && (
              <div className="bg-red-100 text-red-700 p-3 rounded-lg mb-6 text-center">
                {error}
              </div>
            )}

            {results.length > 0 ? (
              <>
                <h2 className="text-xl font-semibold mb-4 text-gray-700 text-center md:text-left">
                  計算結果
                </h2>

                <div
                  className="
                    flex flex-col gap-4
                    max-h-[70vh] overflow-y-auto
                    pr-2 scrollbar-thin scrollbar-thumb-gray-300 scrollbar-track-gray-100
                  "
                >
                  {results.map((r, i) => (
                    <ResultCard key={i} result={r} />
                  ))}
                </div>
              </>
            ) : (
              <p className="text-gray-500 text-center md:text-left">
                結果はここに表示されます。
              </p>
            )}
          </div>
        </div>
      </div>
    </main>
  );
}
