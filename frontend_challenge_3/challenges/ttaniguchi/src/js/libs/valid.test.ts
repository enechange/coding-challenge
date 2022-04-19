import { fixNum, isEmail, zen2han } from './valid';

describe('utils/valid/fixNum', () => {
  test('正常系', (): void => {
    expect(fixNum('12345', '1234')).toBe('12345');
    expect(fixNum('1234a', '1234')).toBe('1234');
  });
});

describe('utils/valid/isEmail', () => {
  test('正常系', (): void => {
    expect(isEmail('test@example.com')).toBeTruthy();
    expect(isEmail('test@example.co.jp')).toBeTruthy();
    expect(isEmail('test.!#$%&*+=\\/?^_`{|}~-@example.co.jp')).toBeTruthy();
  });
  test('異常系', (): void => {
    expect(isEmail('@example.com')).toBeFalsy(); // アカウント部がない
    expect(isEmail('test.example.com')).toBeFalsy(); // @がない
    expect(isEmail('test@example')).toBeFalsy(); // トップレベルドメインがない
  });
});

describe('utils/valid/zen2han', () => {
  test('全角のみ', (): void => {
    expect(
      zen2han('ａｚＡＺ０９．！＃＄％＆＇＊＋＼／＝？＾＿｀｛｜｝～－'),
    ).toEqual("azAZ09.!#$%&'*+\\/=?^_`{|}~-");
  });
  test('半角のみ', (): void => {
    expect(zen2han('12345678')).toEqual('12345678');
  });
  test('混在', (): void => {
    expect(zen2han('1234５６７８')).toEqual('12345678');
  });
});
