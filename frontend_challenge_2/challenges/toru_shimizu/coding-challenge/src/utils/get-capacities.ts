import { Company, Plan } from "../types/simulator";

/**
 *
 * @param min 最小値
 * @param max 最大値
 * @param range 間隔
 * @param unit 単位
 * @returns 最小値から最大値までの間隔ごとの配列
 * @example
 * createRanges({min: 6, max: 49, range:1, unit:'kVA'}); // => ["6kVA", "7kVA", "8kVA" ... "49kVA""]
 * createRanges({min: 10, max: 60, range:10, unit:'A'}); // => ["10A", "20A", "30A" ... "60A""]
 */
const createRanges = ({
  min,
  max,
  range,
  unit,
}: {
  min: number;
  max: number;
  range: number;
  unit?: string;
}): string[] => {
  const results: string[] = [];
  for (let i = min; i <= max; i += range) {
    results.push(`${i}${unit ?? ""}`);
  }
  return results;
};

/**
 * 電力会社のリストを返す。先頭が1の場合は東京電力、先頭が5の場合は関西電力、それ以外は空配列を返す
 * @param company 電力会社
 * @param plan プラン
 * @returns 契約可能な容量一覧
 * @example
 * getCapacities({company: "東京電力", plan: "従量電灯B"}); // => ["10A", "15A", "20A" ... "60A""]
 * getCapacities({company: "関西電力", plan: "従量電灯B"}); // => ["6kVA", "7kVA", "8kVA" ... "49kVA""]
 */
export const getCapacities = ({
  company,
  plan,
}: {
  company: Company;
  plan: Plan;
}): string[] => {
  switch (company) {
    case "東京電力": {
      if (plan === "従量電灯C") {
        return createRanges({ min: 6, max: 49, range: 1, unit: "kVA" });
      }

      return [
        "10A",
        "15A",
        ...createRanges({ min: 20, max: 60, range: 10, unit: "A" }),
      ];
    }

    case "関西電力": {
      if (plan === "従量電灯A") return [];
      return createRanges({ min: 6, max: 49, range: 1, unit: "kVA" });
    }

    default:
      return [];
  }
};
