import { PowerArea } from "@/types";

/**
 * 郵便番号からエリア判定ロジック
 * 共通化された判定ロジック
 */
export function checkAreaLogic(postalCode: string): {
  area: PowerArea;
  isValid: boolean;
  message: string;
} {
  const firstDigit = postalCode.charAt(0);

  const areaMap: Record<string, PowerArea> = {
    "1": "tokyo",
    "5": "kansai",
  };

  const area = areaMap[firstDigit] ?? "out-of-service";
  const isValid = area !== "out-of-service";
  const message = isValid ? "" : "サービスエリア対象外です。";

  return { area, isValid, message };
}
