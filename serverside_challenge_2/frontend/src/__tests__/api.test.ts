import { describe, it, expect, vi, beforeEach } from "vitest";
import { fetchSimulations, ApiValidationError } from "@/lib/api";

beforeEach(() => {
  vi.restoreAllMocks();
});

describe("fetchSimulations", () => {
  it("200 レスポンスで data 配列を返す", async () => {
    const mockData = [{ provider_name: "東京電力", plan_name: "従量電灯B", price: 8010 }];
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: true,
      status: 200,
      json: () => Promise.resolve({ data: mockData }),
    }));

    const result = await fetchSimulations({ ampere: 30, kwh: 300 });
    expect(result).toEqual(mockData);
  });

  it("400 レスポンスで ApiValidationError を throw する", async () => {
    const mockErrors = [
      {
        status: "400",
        title: "Invalid Parameter",
        detail: "kwh は 9999 以下を指定してください",
        source: { parameter: "kwh" },
      },
    ];
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: false,
      status: 400,
      json: () => Promise.resolve({ errors: mockErrors }),
    }));

    await expect(fetchSimulations({ ampere: 30, kwh: 99999 })).rejects.toThrow(
      ApiValidationError
    );
  });

  it("400 エラーの detail が message に含まれる", async () => {
    const detail = "kwh は 9999 以下を指定してください";
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: false,
      status: 400,
      json: () => Promise.resolve({ errors: [{ status: "400", title: "Invalid Parameter", detail, source: { parameter: "kwh" } }] }),
    }));

    await expect(fetchSimulations({ ampere: 30, kwh: 99999 })).rejects.toThrow(detail);
  });

  it("ネットワーク障害で汎用エラーを throw する", async () => {
    vi.stubGlobal("fetch", vi.fn().mockRejectedValue(new Error("Network Error")));

    await expect(fetchSimulations({ ampere: 30, kwh: 300 })).rejects.toThrow("Network Error");
  });

  it("500 レスポンスでサーバーエラーメッセージを throw する", async () => {
    vi.stubGlobal("fetch", vi.fn().mockResolvedValue({
      ok: false,
      status: 500,
      json: () => Promise.resolve({}),
    }));

    await expect(fetchSimulations({ ampere: 30, kwh: 300 })).rejects.toThrow("500");
  });
});
