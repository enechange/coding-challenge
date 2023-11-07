import { getCompanies } from "../utils/get-companies";

describe("getCompanies", () => {
  test("郵便番号の上1桁が1の場合、['東京電力', 'その他']が返される", () => {
    const result = getCompanies("1001000");
    expect(result).toEqual(["東京電力", "その他"]);
  });
  test("郵便番号の上1桁が5の場合、['関西電力', 'その他']が返される", () => {
    const result = getCompanies("5005000");
    expect(result).toEqual(["関西電力", "その他"]);
  });
  test("郵便番号の上1桁が1もしくは5以外の場合、空配列が返される", () => {
    const result = getCompanies("3003000");
    expect(result).toEqual([]);
  });
});
