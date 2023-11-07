import { z } from "zod";

const MIN_PRICE = 1000;
const POSTAL_CODE_REGEX = /^[1,5]/;

export const formSchema = z.object({
  postalCode: z
    .string()
    .min(1, { message: "郵便番号を入力してください。" })
    .regex(/\d/, { message: "半角数字で入力してください。" })
    .regex(POSTAL_CODE_REGEX, { message: "サービスエリア対象外です。" }),
  company: z
    .string()
    .min(1, { message: "電力会社を選択してください。" })
    .refine((value) => value !== "その他", {
      message: "シミュレーション対象外です。",
    }),
  plan: z.string().min(1, { message: "プランを選択してください。" }),
  capacity: z.string().min(1, { message: "容量を選択してください。" }),
  price: z
    .string()
    .min(1, { message: "電気代を入力してください。" })
    .refine((value) => Number(value) >= MIN_PRICE, {
      message: "電気代を1000円以上で入力してください。",
    }),
  email: z
    .string()
    .min(1, { message: "メールアドレスを入力してください。" })
    .max(255, {
      message: "メールアドレスは255文字以内で入力してください。",
    })
    .email({ message: "メールアドレスの形式が正しくありません。" }),
});
