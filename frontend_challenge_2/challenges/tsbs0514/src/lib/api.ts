import { AreaCheckResponse } from "@/types";
import { checkAreaLogic } from "./areaCheck";

/**
 * 郵便番号からエリア判定
 * 静的エクスポート環境ではクライアントサイドで判定
 */
export async function checkArea(
  postalCode: string
): Promise<AreaCheckResponse> {
  // 開発環境ではMSWを使用、本番環境ではクライアントサイドで判定
  if (process.env.NODE_ENV === "development") {
    const response = await fetch("/e-coding-challenge/api/area-check", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ postalCode }),
    });

    if (!response.ok) {
      throw new Error("エリアチェックに失敗しました");
    }

    return response.json();
  } else {
    // 本番環境（静的エクスポート）ではクライアントサイドで判定
    return checkAreaLogic(postalCode);
  }
}
