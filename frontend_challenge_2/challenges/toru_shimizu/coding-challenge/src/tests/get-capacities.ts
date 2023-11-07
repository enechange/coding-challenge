import { getCapacities } from "../utils/get-capacities";

const expected = [
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
];

describe("getCapacities", () => {
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
