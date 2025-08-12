import { z } from "zod";

/**
 * 郵便番号のバリデーション（前半3桁）
 */
export const postalCodeFirstSchema = z
  .string()
  .regex(/^\d{3}$/, "3桁の数字で入力してください");

/**
 * 郵便番号のバリデーション（後半4桁）
 */
export const postalCodeSecondSchema = z
  .string()
  .regex(/^\d{4}$/, "4桁の数字で入力してください");

/**
 * 電力会社のスキーマ
 */
export const powerCompanySchema = z
  .enum(["", "tokyo-electric", "kansai-electric", "other"])
  .refine((value) => value !== "", "電力会社を選択してください");

/**
 * 電気プランのスキーマ
 */
export const electricPlanSchema = z
  .enum([
    "",
    "tokyo-juryou-b",
    "tokyo-juryou-c",
    "kansai-juryou-a",
    "kansai-juryou-b",
  ])
  .refine((value) => value !== "", "プランを選択してください");

/**
 * 契約容量のスキーマ（関西電力従量電灯Aプランでは不要）
 */
export const contractCapacitySchema = z
  .enum([
    // 東京電力従量電灯B
    "10A",
    "15A",
    "20A",
    "30A",
    "40A",
    "50A",
    "60A",
    // 東京電力従量電灯C、関西電力従量電灯B (6kVA-49kVA)
    "6kVA",
    "7kVA",
    "8kVA",
    "9kVA",
    "10kVA",
    "11kVA",
    "12kVA",
    "13kVA",
    "14kVA",
    "15kVA",
    "16kVA",
    "17kVA",
    "18kVA",
    "19kVA",
    "20kVA",
    "21kVA",
    "22kVA",
    "23kVA",
    "24kVA",
    "25kVA",
    "26kVA",
    "27kVA",
    "28kVA",
    "29kVA",
    "30kVA",
    "31kVA",
    "32kVA",
    "33kVA",
    "34kVA",
    "35kVA",
    "36kVA",
    "37kVA",
    "38kVA",
    "39kVA",
    "40kVA",
    "41kVA",
    "42kVA",
    "43kVA",
    "44kVA",
    "45kVA",
    "46kVA",
    "47kVA",
    "48kVA",
    "49kVA",
  ])
  .optional();

/**
 * 電気代のバリデーション（1000円以上）
 */
export const electricBillSchema = z
  .number({ message: "電気代を正しく入力してください。" })
  .min(1000, "電気代を正しく入力してください。");

/**
 * メールアドレスのバリデーション
 */
export const emailSchema = z.email("メールアドレスを正しく入力してください。");

/**
 * メインフォームのスキーマ（メールアドレス削除、郵便番号分割対応）
 */
export const electricSimulationFormSchema = z
  .object({
    postalCodeFirst: postalCodeFirstSchema,
    postalCodeSecond: postalCodeSecondSchema,
    powerCompany: powerCompanySchema,
    plan: electricPlanSchema,
    contractCapacity: contractCapacitySchema,
    currentElectricBill: electricBillSchema,
    email: emailSchema,
  })
  .refine(
    (data) => {
      // すべてのフィールドが入力されている場合のみバリデーション実行
      if (
        !data.powerCompany ||
        !data.plan ||
        data.currentElectricBill === undefined
      ) {
        return true;
      }

      // プランに応じた契約容量の必須チェック
      if (data.plan === "kansai-juryou-a") {
        // 関西電力従量電灯Aは契約容量不要
        return true;
      }
      // その他のプランでは契約容量が必須
      return !!data.contractCapacity;
    },
    {
      message: "契約容量を選択してください",
      path: ["contractCapacity"],
    }
  );

export type ElectricSimulationFormData = z.infer<
  typeof electricSimulationFormSchema
>;
