import { halfWidthNumber } from "@/util/stringUtil";

describe("stringUtil", () => {
  describe("halfWidthNumber", () => {
    it("全角数字が半角数字に変換される", () => {
      const value = halfWidthNumber("１２３４");
      expect(value).toEqual("1234");
    });

    it("全角文字は変換されずに数字のみが半角に変換される", () => {
      const value = halfWidthNumber("１２３４あ");
      expect(value).toEqual("1234あ");
    });
  });
});
