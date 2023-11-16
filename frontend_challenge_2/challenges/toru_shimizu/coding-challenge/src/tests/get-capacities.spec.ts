import { createRanges, getCapacities } from "../utils/get-capacities";

describe("getCapacities", () => {
  const expected = createRanges({ min: 6, max: 49, range: 1, unit: "kVA" });
  test("東京電力 + 従量電灯Bの場合、10A/15A/20A/30A/40A/50A/60Aが選択肢として返される", () => {
    const result = getCapacities({ company: "東京電力", plan: "従量電灯B" });
    expect(result).toEqual(["10A", "15A", "20A", "30A", "40A", "50A", "60A"]);
  });
  test("東京電力 + 従量電灯Cの場合、6kVAから49kVAまで1kVA刻みの選択肢が返される", () => {
    const result = getCapacities({ company: "東京電力", plan: "従量電灯C" });
    expect(result).toEqual(expected);
  });
  test("関西電力 + 従量電灯Aの場合、空配列が返される", () => {
    const result = getCapacities({ company: "関西電力", plan: "従量電灯A" });
    expect(result).toEqual([]);
  });
  test("関西電力 + 従量電灯Bの場合、6kVAから49kVAまで1kVA刻みの選択肢が返される", () => {
    const result = getCapacities({ company: "関西電力", plan: "従量電灯B" });
    expect(result).toEqual(expected);
  });
});
