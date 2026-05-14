import { z } from "zod";
import { VALID_AMPERES, MAX_KWH } from "@/lib/constants";

const [first, ...rest] = VALID_AMPERES;
export const simulationFormSchema = z.object({
  ampere: z.union([z.literal(first), ...rest.map((a) => z.literal(a))]),
  // Zod v4: z.number({ error }) コールバックは invalid_type のみ。
  // min/max/int のメッセージは第 2 引数で渡す
  kwh: z
    .number({
      // error コールバックで未入力（undefined）と型エラーを日本語化
      error: () => "使用量を入力してください",
    })
    .int("整数を入力してください")
    .min(0, "0以上を入力してください")
    .max(MAX_KWH, `${MAX_KWH}以下を入力してください`),
});

export type SimulationFormValues = z.infer<typeof simulationFormSchema>;
