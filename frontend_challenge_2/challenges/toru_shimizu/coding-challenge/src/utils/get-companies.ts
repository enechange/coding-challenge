const TOKYO_AREA_REGEX = /^[1]/;
const KANSAI_AREA_REGEX = /^[5]/;

/**
 * 電力会社のリストを返す。先頭が1の場合は東京電力、先頭が5の場合は関西電力、それ以外は空配列を返す
 * @param postalCode 郵便番号
 * @returns 電力会社のリスト
 * @example
 * getCompanies("1000000"); // => ["東京電力", "その他"]
 * getCompanies("5000000"); // => ["関西電力", "その他"]
 */
export const getCompanies = (postalCode: string): string[] => {
  const defaultOptions = ["その他"];

  if (TOKYO_AREA_REGEX.test(postalCode)) return ["東京電力", ...defaultOptions];
  if (KANSAI_AREA_REGEX.test(postalCode))
    return ["関西電力", ...defaultOptions];
  return [];
};