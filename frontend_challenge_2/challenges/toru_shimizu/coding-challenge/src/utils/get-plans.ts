/**
 * 選択可能なプラン一覧を返す
 * @param company 電力会社
 * @returns 選択可能なプラン一覧
 * @example
 * getPlans("東京電力"); // => ["従量電灯B", "従量電灯C"]
 * getPlans("関西電力"); // => ["従量電灯A", "従量電灯B"]
 */
export const getPlans = (company: string): string[] => {
  const defaultOptions = ["従量電灯B"];

  switch (company) {
    case "東京電力":
      return [...defaultOptions, "従量電灯C"];
    case "関西電力":
      return ["従量電灯A", ...defaultOptions];
    default:
      return [];
  }
};
