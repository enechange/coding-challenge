/**
 * usePlan
 * プラン選択に関するロジックを集約するhooks。
 * - 電力会社に応じたプラン選択肢の提供
 * - 選択中プランの情報/説明文/表示ラベルの提供
 * - プランセクションの表示可否
 * 返却値:
 * - getAvailablePlans: プラン選択肢の取得関数
 * - isPlanVisible: プランセクションの表示可否
 * - selectedPlanOption: 選択中プランのオブジェクト
 * - planDescription: プラン説明文
 * - planLabel: 表示用ラベル
 */
import { useCallback, useMemo } from "react";
import type { ElectricPlan } from "@/types";
import { TOKYO_PLANS, KANSAI_PLANS, PLAN_LABELS } from "@/constants/options";

export function usePlan(
  watchedPowerCompany: string,
  watchedPlan: ElectricPlan | ""
) {
  const getAvailablePlans = useCallback(() => {
    if (!watchedPowerCompany || watchedPowerCompany === "other") return [];
    return watchedPowerCompany === "tokyo-electric"
      ? TOKYO_PLANS
      : KANSAI_PLANS;
  }, [watchedPowerCompany]);

  const isPlanVisible = useMemo(
    () => Boolean(watchedPowerCompany && watchedPowerCompany !== "other"),
    [watchedPowerCompany]
  );

  const selectedPlanOption = useMemo(() => {
    if (!watchedPlan) return undefined;
    const plans = getAvailablePlans();
    return plans.find((p) => p.value === watchedPlan);
  }, [watchedPlan, getAvailablePlans]);

  const planDescription = selectedPlanOption?.description || "";

  const planLabel = useMemo(() => {
    return watchedPlan
      ? PLAN_LABELS[watchedPlan as Exclude<ElectricPlan, "">] || watchedPlan
      : "";
  }, [watchedPlan]);

  return {
    getAvailablePlans,
    isPlanVisible,
    selectedPlanOption,
    planDescription,
    planLabel,
  } as const;
}
