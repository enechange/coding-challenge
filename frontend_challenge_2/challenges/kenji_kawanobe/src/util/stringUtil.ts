// 全角数字を半角数字に変換
export function halfWidthNumber(value: string): string {
  if (!value) return "";
  return value.replace(/[０-９]/g, (s: string) => {
    return String.fromCharCode(s.charCodeAt(0) - 0xfee0);
  });
}
