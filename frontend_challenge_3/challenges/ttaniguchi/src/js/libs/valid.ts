const REGEX: Record<string, RegExp> = {
  EMAIL:
    /^[a-zA-Z0-9.!#$%&'*+\\/=?^_`{|}~-]+@([a-zA-Z0-9_.-]){1,}(\.)+([a-zA-Z0-9]{2,})$/,
  NUMBER_ONLY: /^[0-9]{1,}$/,
  ZEN: /[ａ-ｚＡ-Ｚ０-９．！＃＄％＆＇＊＋＼＼／＝？＾＿｀｛｜｝～－]/g,
} as const;

export const fixNum = (value: string, prevValue: string): string =>
  REGEX.NUMBER_ONLY.test(value) ? value : prevValue;
export const isEmail = (email: string): boolean => REGEX.EMAIL.test(email);

export const zen2han = (value: string) => {
  return value.replace(REGEX.ZEN, (s) =>
    String.fromCharCode(s.charCodeAt(0) - 65248),
  );
};
