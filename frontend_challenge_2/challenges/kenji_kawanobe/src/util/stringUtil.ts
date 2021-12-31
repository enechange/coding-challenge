// TODO: UT追加;
export function halfWidthNumber(value: string): string {
  return value.replace(/[０-９]/g, (s: string) => {
    return String.fromCharCode(s.charCodeAt(0) - 0xfee0);
  });
}
