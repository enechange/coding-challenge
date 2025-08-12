/**
 * usePowerCompany
 * 電力会社選択に関するロジックを集約するフック。
 * - エリアに応じた電力会社の選択肢提供
 * - 「その他」選択時のエラーハンドリングと下位フィールドのリセット
 * - 表示用の正式名称ラベルの提供
 * 返却値:
 * - companyError: 電力会社に関するエラー文言
 * - getAvailablePowerCompanies: 電力会社選択肢の取得関数
 * - companyLabel: 選択された会社の正式名称
 */
import { useEffect, useMemo, useState, useCallback } from "react";
import type { UseFormReturn } from "react-hook-form";
import type { ElectricSimulationFormData } from "@/schemas";
import type { PowerArea, PowerCompany } from "@/types";
import {
  COMPANY_OPTIONS_BY_AREA,
  POWER_COMPANY_LABELS,
  type LabeledOption,
} from "@/constants/options";

export function usePowerCompany(
  form: UseFormReturn<ElectricSimulationFormData>,
  currentArea: PowerArea | null,
  watchedPowerCompany: PowerCompany | ""
) {
  const { resetField } = form;

  const [companyError, setCompanyError] = useState<string>("");

  const handlePowerCompanyChange = useCallback(() => {
    try {
      if (watchedPowerCompany === "other") {
        setCompanyError("シミュレーション対象外です。");
        resetField("plan");
        resetField("contractCapacity");
      } else {
        setCompanyError("");
      }
    } catch {
      setCompanyError("電力会社チェックに失敗しました");
    }
  }, [resetField, watchedPowerCompany]);

  useEffect(() => {
    if (watchedPowerCompany) handlePowerCompanyChange();
  }, [watchedPowerCompany, handlePowerCompanyChange]);

  const getAvailablePowerCompanies = useCallback((): ReadonlyArray<
    LabeledOption<PowerCompany>
  > => {
    if (!currentArea || currentArea === "out-of-service") return [];
    return COMPANY_OPTIONS_BY_AREA[currentArea];
  }, [currentArea]);

  const companyLabel = useMemo(() => {
    return watchedPowerCompany
      ? POWER_COMPANY_LABELS[
          (watchedPowerCompany as Exclude<PowerCompany, "">) || "other"
        ] || watchedPowerCompany
      : "";
  }, [watchedPowerCompany]);

  return {
    companyError,
    getAvailablePowerCompanies,
    companyLabel,
  } as const;
}
