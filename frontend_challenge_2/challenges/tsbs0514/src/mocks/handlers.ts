import { http, HttpResponse } from "msw";
import { checkAreaLogic } from "@/lib/areaCheck";

/**
 * 郵便番号からエリア判定API
 */
export const areaCheckHandler = http.post(
  "/e-coding-challenge/api/area-check",
  async ({ request }) => {
    const { postalCode } = (await request.json()) as { postalCode: string };

    const result = checkAreaLogic(postalCode);

    return HttpResponse.json(result);
  }
);

export const handlers = [areaCheckHandler];
