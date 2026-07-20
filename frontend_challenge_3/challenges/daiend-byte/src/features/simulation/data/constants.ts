export const MIN_ELECTRICITY_BILL = 1000;

export const SIMULATION_NOT_SUPPORTED_MESSAGE = 'シミュレーション対象外です。';

// 郵便番号は上3桁・下4桁の2欄に分割して入力させる（zip-code-input.tsx）
export const ZIP_CODE_PREFIX_LENGTH = 3;
export const ZIP_CODE_SUFFIX_LENGTH = 4;
export const ZIP_CODE_LENGTH = ZIP_CODE_PREFIX_LENGTH + ZIP_CODE_SUFFIX_LENGTH;
export const ZIP_CODE_REGEX = new RegExp(
    `^\\d{${ZIP_CODE_LENGTH.toString()}}$`,
);

export const MIN_KVA = 6;
export const MAX_KVA = 49;
