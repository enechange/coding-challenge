export const VALIDATION_MESSAGES = {
  POSTAL_CODE: {
    NUMBERS_ONLY: '半角数字のみで入力してください。',
    OUT_OF_SERVICE_AREA: 'サービスエリア対象外です。',
  },
  POWER_COMPANY: {
    NOT_SUPPORTED: 'シミュレーション対象外です。',
  },
  AMOUNT: {
    NUMBERS_ONLY: '半角数字のみで入力してください。',
    MINIMUM_AMOUNT: '電気代を正しく入力してください。',
  },
  MAIL_ADDRESS: {
    INVALID_FORMAT: 'メールアドレスを正しく入力してください。',
  },
} as const;
