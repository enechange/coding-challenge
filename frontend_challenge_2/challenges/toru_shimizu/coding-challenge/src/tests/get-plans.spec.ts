import { getPlans } from "../utils/get-plans";

describe("getPlans", () => {
  test("東京電力を選択した場合、['従量電灯B', '従量電灯C']が返される", () => {
    const result = getPlans("東京電力");
    expect(result).toEqual(["従量電灯B", "従量電灯C"]);
  });
  test("関西電力を選択した場合、['従量電灯A', '従量電灯B']が返される", () => {
    const result = getPlans("関西電力");
    expect(result).toEqual(["従量電灯A", "従量電灯B"]);
  });
  test("その他を選択した場合、空配列が返される", () => {
    const result = getPlans("その他");
    expect(result).toEqual([]);
  });
});
