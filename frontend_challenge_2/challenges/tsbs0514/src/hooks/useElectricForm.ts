/**
 * useElectricForm
 * 電気料金シミュレーションフォームに関するロジックを集約するhooks。
 * - フォームの初期化
 * - 各フィールドのリセット
 * - 郵便番号・エリアロジック
 * - 電力会社・プラン・容量・ラベル等のロジック
 * - エリア変更時に下位の選択値をリセット
 */

import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { useState, useCallback, useEffect, useRef, useMemo } from "react";
import {
  electricSimulationFormSchema,
  ElectricSimulationFormData,
} from "@/schemas";
import { PowerArea } from "@/types";
import { usePostalArea } from "@/hooks/usePostalArea";
import { usePowerCompany } from "@/hooks/usePowerCompany";
import { usePlan } from "@/hooks/usePlan";
import { useCapacities } from "@/hooks/useCapacities";

export function useElectricForm() {
  const [isSubmitting, setIsSubmitting] = useState(false);

  const form = useForm<ElectricSimulationFormData>({
    resolver: zodResolver(electricSimulationFormSchema),
    mode: "onChange",
    defaultValues: {
      postalCodeFirst: "",
      postalCodeSecond: "",
      powerCompany: "",
      plan: "",
      contractCapacity: undefined,
      currentElectricBill: undefined,
      email: "",
    },
  });

  const { watch, resetField } = form;

  const resetSelectedFields = useCallback(() => {
    resetField("powerCompany");
    resetField("plan");
    resetField("contractCapacity");
  }, [resetField]);

  // 郵便番号・エリアロジック（自動フォーカス含む）
  const { currentArea, areaError } = usePostalArea(form);

  // 電力会社・プラン・容量・ラベル等のロジック
  const watchedPowerCompany = watch("powerCompany");
  const watchedPlan = watch("plan");

  const { companyError, getAvailablePowerCompanies, companyLabel } =
    usePowerCompany(form, currentArea, watchedPowerCompany);

  const {
    getAvailablePlans,
    isPlanVisible,
    selectedPlanOption,
    planDescription,
    planLabel,
  } = usePlan(watchedPowerCompany, watchedPlan);

  const {
    getAvailableCapacities,
    isCapacityVisible,
    isContractCapacityRequired,
    capacityPromptError,
  } = useCapacities(form, watchedPlan);

  const isDetailsSectionVisible = useMemo(() => {
    return (
      Boolean(watchedPlan) && !!currentArea && currentArea !== "out-of-service"
    );
  }, [watchedPlan, currentArea]);

  // エリア変更時に下位の選択値をリセット
  const prevAreaRef = useRef<PowerArea | null>(null);
  useEffect(() => {
    if (prevAreaRef.current !== currentArea) {
      if (prevAreaRef.current !== null) {
        resetSelectedFields();
      }
      prevAreaRef.current = currentArea;
    }
  }, [currentArea, resetSelectedFields]);

  return {
    form,
    currentArea,
    areaError,
    companyError,
    isSubmitting,
    isPlanVisible,
    isCapacityVisible,
    selectedPlanOption,
    planDescription,
    companyLabel,
    planLabel,
    isDetailsSectionVisible,
    setIsSubmitting,
    getAvailablePowerCompanies,
    getAvailablePlans,
    getAvailableCapacities,
    isContractCapacityRequired,
    capacityPromptError,
  };
}
