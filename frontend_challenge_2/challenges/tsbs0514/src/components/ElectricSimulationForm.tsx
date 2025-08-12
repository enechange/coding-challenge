"use client";

import React from "react";
import { useElectricForm } from "@/hooks/useElectricForm";

import { Input } from "@/components/ui/Input";
import { Select, SelectOption } from "@/components/ui/Select";
import { Button } from "@/components/ui/Button";
import { ElectricSimulationFormData } from "@/schemas";
import type { PowerCompany, ElectricPlan } from "@/types";
import { POWER_COMPANY_LABELS, PLAN_LABELS } from "@/constants/options";
import { Section } from "./layout/Section";
import { FormField } from "./ui/FormField";
import { FaCircleChevronRight } from "react-icons/fa6";

interface ElectricSimulationFormProps {
  onSubmit?: () => void;
}

export function ElectricSimulationForm({
  onSubmit,
}: ElectricSimulationFormProps) {
  const {
    form,
    currentArea,
    areaError,
    companyError,
    isSubmitting,
    isPlanVisible,
    isCapacityVisible,
    planDescription,
    isDetailsSectionVisible,
    capacityPromptError,
    setIsSubmitting,
    getAvailablePowerCompanies,
    getAvailablePlans,
    getAvailableCapacities,
  } = useElectricForm();

  const {
    register,
    handleSubmit,
    formState: { errors, isValid },
  } = form;

  const handleFormSubmit = async (data: ElectricSimulationFormData) => {
    if (areaError || companyError) return;

    // フォームデータの完全性チェック
    if (
      !data.postalCodeFirst ||
      !data.postalCodeSecond ||
      !data.powerCompany ||
      !data.plan ||
      !data.currentElectricBill ||
      !data.email
    ) {
      alert("すべての項目を入力してください");
      return;
    }

    setIsSubmitting(true);
    try {
      const companyLabel =
        POWER_COMPANY_LABELS[
          (data.powerCompany as Exclude<PowerCompany, "">) || "other"
        ] || data.powerCompany;

      const planLabel =
        PLAN_LABELS[data.plan as Exclude<ElectricPlan, "">] || data.plan;
      // シミュレーション成功のメッセージ表示
      alert(
        `シミュレーション完了！\n\n` +
          `郵便番号: ${data.postalCodeFirst}-${data.postalCodeSecond}\n` +
          `電力会社: ${companyLabel}\n` +
          `プラン: ${planLabel}\n` +
          `契約容量: ${data.contractCapacity || "なし"}\n` +
          `現在の電気代: ${data.currentElectricBill?.toLocaleString()}円`
      );
      onSubmit?.();
    } catch (error) {
      console.error("Simulation failed:", error);
      alert("シミュレーションに失敗しました。もう一度お試しください。");
    } finally {
      setIsSubmitting(false);
    }
  };

  const isFormValid =
    isValid && !areaError && !companyError && currentArea !== "out-of-service";

  return (
    <div className="max-w-md mx-auto">
      {/* ヘッダー */}
      <div className="text-center p-4 mb-8">
        <h1 className="text-xl font-bold text-gray-700 mb-3 tracking-wide">
          電気代から
          <br />
          かんたんシミュレーション
        </h1>
        <p className="text-sm text-gray-700 leading-relaxed">
          検針票を用意しなくてもOK
          <br />
          いくらおトクになるのか今すぐわかります！
        </p>
      </div>

      <form
        onSubmit={handleSubmit(handleFormSubmit)}
        className="flex flex-col gap-7"
      >
        {/* 郵便番号セクション */}
        <Section title="郵便番号をご入力ください">
          <FormField
            label="電気を使用する場所の郵便番号"
            labelHtmlFor="postalCodeFirst"
            error={
              errors.postalCodeFirst?.message ||
              errors.postalCodeSecond?.message ||
              areaError
            }
            required
          >
            <div className="flex items-center gap-2 bg-gray-200 rounded-sm">
              <Input
                {...register("postalCodeFirst")}
                id="postalCodeFirst"
                placeholder="130"
                maxLength={3}
                className="text-center flex-1"
                error={!!errors.postalCodeFirst || !!areaError}
              />
              <span className="text-gray-500">-</span>
              <Input
                {...register("postalCodeSecond")}
                id="postalCodeSecond"
                placeholder="0012"
                maxLength={4}
                className="text-center flex-1"
                error={!!errors.postalCodeSecond || !!areaError}
              />
            </div>
          </FormField>
        </Section>

        {/* 電気使用状況セクション */}
        {currentArea && currentArea !== "out-of-service" && (
          <Section title="電気のご使用状況について教えてください">
            <div className="flex flex-col gap-10">
              {/* 電力会社 */}
              <FormField
                label="電力会社"
                labelHtmlFor="powerCompany"
                error={companyError}
                required
              >
                <Select
                  {...register("powerCompany")}
                  id="powerCompany"
                  options={getAvailablePowerCompanies()}
                  placeholder="電力会社を選択してください"
                  error={!!errors.powerCompany || !!companyError}
                  className="w-full"
                />
              </FormField>

              {/* プラン */}
              {isPlanVisible && (
                <FormField
                  label="プラン"
                  labelHtmlFor="plan"
                  required
                  description={planDescription}
                >
                  <Select
                    {...register("plan")}
                    id="plan"
                    options={getAvailablePlans()}
                    placeholder="プランを選択してください"
                    error={!!errors.plan}
                    className="w-full"
                  />
                </FormField>
              )}

              {/* 契約容量 */}
              {isCapacityVisible && (
                <FormField
                  label="契約容量"
                  labelHtmlFor="contractCapacity"
                  required
                  error={
                    capacityPromptError || errors.contractCapacity?.message
                  }
                >
                  <Select
                    {...register("contractCapacity")}
                    id="contractCapacity"
                    options={getAvailableCapacities() as SelectOption[]}
                    placeholder="契約容量を選択してください"
                    error={!!errors.contractCapacity}
                    className="w-full"
                  />
                </FormField>
              )}
            </div>
          </Section>
        )}

        {/* 現在の電気代・ユーザー情報セクション & 送信ボタン */}
        {isDetailsSectionVisible && (
          <>
            {/* 現在の電気代 */}
            <Section title="現在の電気の使用状況について教えてください">
              <FormField
                label="先月の電気代は？"
                labelHtmlFor="currentElectricBill"
                required
                error={errors.currentElectricBill?.message}
              >
                <div className="flex items-center">
                  <Input
                    {...register("currentElectricBill", {
                      valueAsNumber: true,
                    })}
                    id="currentElectricBill"
                    type="number"
                    placeholder="5000"
                    min="1000"
                    error={!!errors.currentElectricBill}
                    className="flex-1"
                  />
                  <span className="ml-2 text-gray-700">円</span>
                </div>
              </FormField>
            </Section>

            {/* ユーザー情報 */}
            <Section title="ユーザー情報をご入力ください">
              <FormField
                label="メールアドレス"
                labelHtmlFor="email"
                required
                error={errors.email?.message}
              >
                <Input
                  {...register("email")}
                  id="email"
                  type="email"
                  placeholder="メールアドレス"
                />
              </FormField>
            </Section>

            {/* 送信ボタン */}
            <div className="py-2.5 px-4">
              <Button
                type="submit"
                disabled={!isFormValid || isSubmitting}
                className="relative w-full"
                loading={isSubmitting}
                iconSuffix={
                  <FaCircleChevronRight
                    className="absolute right-4 w-4 h-4 top-0 bottom-0 m-auto"
                    aria-hidden="true"
                  />
                }
              >
                {isSubmitting ? "シミュレーション中..." : "結果を見る"}
              </Button>
            </div>
          </>
        )}
      </form>
    </div>
  );
}
