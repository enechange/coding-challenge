"use client";

import type { SimulationResult } from "@/types/api";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

const priceFormatter = new Intl.NumberFormat("ja-JP", {
  style: "currency",
  currency: "JPY",
});

type Props = {
  results: SimulationResult[] | null;
  loading: boolean;
  error: string | null;
};

export function SimulationResult({ results, loading, error }: Props) {
  if (loading) {
    return (
      <div className="flex justify-center py-8" role="status" aria-label="計算中">
        <div className="h-8 w-8 animate-spin rounded-full border-4 border-primary border-t-transparent" />
      </div>
    );
  }

  if (error) {
    return (
      <div className="rounded-md bg-destructive/10 p-4 text-destructive text-sm" role="alert">
        {error}
      </div>
    );
  }

  if (results === null) {
    return null;
  }

  if (results.length === 0) {
    return (
      <p className="text-center text-muted-foreground py-8">
        該当するプランが見つかりませんでした
      </p>
    );
  }

  return (
    <div className="space-y-3">
      <p className="text-sm text-muted-foreground">{results.length}件のプランが見つかりました（安い順）</p>
      {results.map((result, index) => (
        <Card key={`${result.provider_name}-${result.plan_name}-${index}`}>
          <CardHeader className="pb-2">
            <CardTitle className="text-base">{result.provider_name}</CardTitle>
          </CardHeader>
          <CardContent className="flex items-center justify-between">
            <span className="text-sm text-muted-foreground">{result.plan_name}</span>
            <span className="text-lg font-bold">{priceFormatter.format(result.price)}</span>
          </CardContent>
        </Card>
      ))}
    </div>
  );
}
