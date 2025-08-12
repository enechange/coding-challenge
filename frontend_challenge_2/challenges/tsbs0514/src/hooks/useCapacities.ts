/**
 * useCapacities
 * 契約容量選択に関するロジックを集約するhooks。
 * - プランに応じた契約容量の選択肢提供
 * - 容量セクションの表示可否/必須判定の提供
 * - プラン変更で容量をリセットした際のみ、再入力促しエラーメッセージを提供
 * 返却値:
 * - getAvailableCapacities: 契約容量選択肢の取得関数
 * - isCapacityVisible: 容量セクションの表示可否
 * - isContractCapacityRequired: 容量が必須かどうか
 * - capacityPromptError: プラン変更によるリセット後のみ表示する促しエラー文言
 */
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import type { UseFormReturn } from "react-hook-form";
import type { ElectricSimulationFormData } from "@/schemas";
import type { ElectricPlan } from "@/types";
import { PLAN_TO_CAPACITIES, type CapacityOption } from "@/constants/options";

export function useCapacities(
  form: UseFormReturn<ElectricSimulationFormData>,
  watchedPlan: ElectricPlan | ""
) {
  const { resetField, watch } = form;
  const [capacityReentryRequired, setCapacityReentryRequired] = useState(false);
  const prevPlanRef = useRef<ElectricPlan | "">("");
  const getAvailableCapacities =
    useCallback((): ReadonlyArray<CapacityOption> => {
      if (!watchedPlan) return [];
      return PLAN_TO_CAPACITIES[watchedPlan as Exclude<ElectricPlan, "">] ?? [];
    }, [watchedPlan]);

  const isCapacityVisible = useMemo(
    () => Boolean(watchedPlan) && watchedPlan !== "kansai-juryou-a",
    [watchedPlan]
  );

  const isContractCapacityRequired = useMemo(
    () => Boolean(watchedPlan) && watchedPlan !== "kansai-juryou-a",
    [watchedPlan]
  );

  const watchedContractCapacity = watch("contractCapacity");

  // プラン変更時の容量リセットと再入力促し
  useEffect(() => {
    if (prevPlanRef.current && prevPlanRef.current !== watchedPlan) {
      const prevCapacity = watchedContractCapacity;
      const nextRequiresCapacity =
        Boolean(watchedPlan) && watchedPlan !== "kansai-juryou-a";
      if (prevCapacity && nextRequiresCapacity) {
        resetField("contractCapacity");
        setCapacityReentryRequired(true);
      } else {
        setCapacityReentryRequired(false);
      }
    }
    prevPlanRef.current = watchedPlan;
  }, [watchedPlan, watchedContractCapacity, resetField]);

  // 容量が再入力されたら促しを解除
  useEffect(() => {
    if (watchedContractCapacity) {
      setCapacityReentryRequired(false);
    }
  }, [watchedContractCapacity]);

  const capacityPromptError = useMemo(() => {
    return capacityReentryRequired &&
      isCapacityVisible &&
      !watchedContractCapacity
      ? "契約容量を再選択してください"
      : "";
  }, [capacityReentryRequired, isCapacityVisible, watchedContractCapacity]);

  return {
    getAvailableCapacities,
    isCapacityVisible,
    isContractCapacityRequired,
    capacityPromptError,
  } as const;
}
