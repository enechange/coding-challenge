/**
 * usePostalArea
 * 郵便番号入力に関するロジックを集約するフック。
 * - 郵便番号の監視（前半/後半）とエリア判定API呼び出し
 * - エリアエラー文言の管理
 * - 前半3桁入力時に後半フィールドへ自動フォーカス
 * 返却値:
 * - currentArea: 判定されたエリア（tokyo/kansai/out-of-service）
 * - areaError: エリアに関するエラー文言
 */
import { useCallback, useEffect, useState } from "react";
import type { UseFormReturn } from "react-hook-form";
import type { ElectricSimulationFormData } from "@/schemas";
import type { PowerArea } from "@/types";
import { checkArea } from "@/lib/api";

export function usePostalArea(form: UseFormReturn<ElectricSimulationFormData>) {
  const { watch, setFocus } = form;

  const [currentArea, setCurrentArea] = useState<PowerArea | null>(null);
  const [areaError, setAreaError] = useState<string>("");

  const watchedPostalCodeFirst = watch("postalCodeFirst");
  const watchedPostalCodeSecond = watch("postalCodeSecond");

  const handlePostalCodeChange = useCallback(
    async (first: string, second: string) => {
      if (first.length === 3 && second.length === 4) {
        const fullPostalCode = first + second;
        try {
          const result = await checkArea(fullPostalCode);
          setCurrentArea(result.area);
          if (!result.isValid) {
            setAreaError(result.message || "");
          } else {
            setAreaError("");
          }
        } catch {
          setAreaError("エリアチェックに失敗しました");
        }
      } else {
        setCurrentArea(null);
        setAreaError("");
      }
    },
    []
  );

  // 郵便番号の監視
  useEffect(() => {
    if (watchedPostalCodeFirst && watchedPostalCodeSecond) {
      handlePostalCodeChange(watchedPostalCodeFirst, watchedPostalCodeSecond);
    }
  }, [watchedPostalCodeFirst, watchedPostalCodeSecond, handlePostalCodeChange]);

  // 郵便番号前半3桁入力で後半へ自動フォーカス
  useEffect(() => {
    if (watchedPostalCodeFirst && watchedPostalCodeFirst.length === 3) {
      setFocus("postalCodeSecond");
    }
  }, [watchedPostalCodeFirst, setFocus]);

  return { currentArea, areaError } as const;
}
