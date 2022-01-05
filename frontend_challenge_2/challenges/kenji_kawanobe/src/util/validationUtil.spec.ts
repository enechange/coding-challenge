import { companyTypes, planTypes, ISimulation } from "@/types";
import {
  isValidZipCode,
  isValidCompany,
  isValidPlan,
  isValidAmps,
  isValidPay,
  isValidEmail,
} from "@/util/validationUtil";

describe("validationUtil", () => {
  describe("isValidZipCode", () => {
    describe("TRUE となるケース", () => {
      it("数字7桁 かつ 先頭1桁が「1」の場合 TRUE(東京電力エリア)", () => {
        const result = isValidZipCode("111", "1234");
        expect(result).toBeTruthy();
      });

      it("数字7桁 かつ 先頭1桁が「5」の場合 TRUE(関西電力エリア)", () => {
        const result = isValidZipCode("555", "1234");
        expect(result).toBeTruthy();
      });
    });

    describe("FALSE となるケース", () => {
      it("先頭1桁が「1 or 5」でない場合 FALSE", () => {
        const result = isValidZipCode("222", "1234");
        expect(result).toBeFalsy();
      });

      it("数字以外の文字列が含まれている場合は FALSE", () => {
        const result = isValidZipCode("1aa", "4567");
        expect(result).toBeFalsy();
      });

      it("eを用いた数字の場合は FALSE", () => {
        const result = isValidZipCode("1e1", "4567");
        expect(result).toBeFalsy();
      });

      it("数字が7桁入力されていない場合は FALSE", () => {
        const result = isValidZipCode("111", "456");
        expect(result).toBeFalsy();
      });
    });
  });

  describe("isValidCompany", () => {
    describe("TRUE となるケース", () => {
      it("東京電力が入力された場合 TRUE", () => {
        const result = isValidCompany(companyTypes.TOKYO_DENRYOKU);
        expect(result).toBeTruthy();
      });

      it("関西電力が入力された場合 TRUE", () => {
        const result = isValidCompany(companyTypes.KANSAI_DENRYOKU);
        expect(result).toBeTruthy();
      });
    });

    describe("FALSE となるケース", () => {
      it("その他が入力された場合 FALSE", () => {
        const result = isValidCompany(companyTypes.OTHER);
        expect(result).toBeFalsy();
      });

      it("未選択の場合 FALSE", () => {
        const result = isValidCompany(companyTypes.UNSELECTED);
        expect(result).toBeFalsy();
      });
    });
  });

  describe("isValidPlan", () => {
    describe("TRUE となるケース", () => {
      it("従量電灯Aが入力された場合 TRUE", () => {
        const result = isValidPlan(planTypes.PLAN_A);
        expect(result).toBeTruthy();
      });

      it("従量電灯Bが入力された場合 TRUE", () => {
        const result = isValidPlan(planTypes.PLAN_B);
        expect(result).toBeTruthy();
      });

      it("従量電灯Cが入力された場合 TRUE", () => {
        const result = isValidPlan(planTypes.PLAN_C);
        expect(result).toBeTruthy();
      });
    });

    describe("FALSE となるケース", () => {
      it("未選択の場合 FALSE", () => {
        const result = isValidPlan(planTypes.UNSELECTED);
        expect(result).toBeFalsy();
      });
    });
  });

  describe("isValidAmps", () => {
    describe("TRUE となるケース", () => {
      it("空文字でない場合 TRUE", () => {
        const simulationData = {
          amps: "10A",
        } as ISimulation;
        const result = isValidAmps(simulationData);
        expect(result).toBeTruthy();
      });

      it("関西電力 かつ 従量電灯A の場合 TRUE", () => {
        const simulationData = {
          company: companyTypes.KANSAI_DENRYOKU,
          plan: planTypes.PLAN_A,
        } as ISimulation;
        const result = isValidAmps(simulationData);
        expect(result).toBeTruthy();
      });
    });

    describe("FALSE となるケース", () => {
      it("関西電力でない かつ 従量電灯Aでない かつ 契約容量が未選択の場合 FALSE", () => {
        const simulationData = {
          amps: "",
        } as ISimulation;
        const result = isValidAmps(simulationData);
        expect(result).toBeFalsy();
      });
    });
  });

  describe("isValidPay", () => {
    describe("TRUE となるケース", () => {
      it("最低料金の場合 TRUE", () => {
        const result = isValidPay("1000");
        expect(result).toBeTruthy();
      });

      it("最低料金以上の場合 TRUE", () => {
        const result = isValidPay("1100");
        expect(result).toBeTruthy();
      });
    });

    describe("FALSE となるケース", () => {
      it("最低料金未満の場合 FALSE", () => {
        const result = isValidPay("999");
        expect(result).toBeFalsy();
      });

      it("eを用いた数字の場合 FALSE", () => {
        const result = isValidPay("1e11");
        expect(result).toBeFalsy();
      });

      it("数字以外の文字が含まれるの場合 TRUE", () => {
        const result = isValidPay("1000test");
        expect(result).toBeFalsy();
      });
    });
  });

  describe("isValidEmail", () => {
    describe("TRUE となるケース", () => {
      it("test@enechange.jp TRUE", () => {
        const result = isValidEmail("test@enechange.jp");
        expect(result).toBeTruthy();
      });

      it("test@enechange.co.jp TRUE", () => {
        const result = isValidEmail("test@enechange.co.jp");
        expect(result).toBeTruthy();
      });

      it("test.ut@enechange.co.jp TRUE", () => {
        const result = isValidEmail("test.ut@enechange.co.jp");
        expect(result).toBeTruthy();
      });
    });

    describe("FALSE となるケース", () => {
      it("test FALSE", () => {
        const result = isValidEmail("test");
        expect(result).toBeFalsy();
      });

      it("test@enechange FALSE", () => {
        const result = isValidEmail("test@enechange");
        expect(result).toBeFalsy();
      });

      it("test.ut@enechange FALSE", () => {
        const result = isValidEmail("test.ut@enechange");
        expect(result).toBeFalsy();
      });

      it("test..ut@enechange FALSE", () => {
        const result = isValidEmail("test..ut@enechange");
        expect(result).toBeFalsy();
      });

      it("test,ut@enechange,co.jp FALSE", () => {
        const result = isValidEmail("test,ut@enechange,co.jp");
        expect(result).toBeFalsy();
      });

      it("1test.1ut@1enechange.1co.jp FALSE", () => {
        const result = isValidEmail("1test.1ut@1enechange.1co.1jp");
        expect(result).toBeFalsy();
      });

      it("テスト.ut@enechange.co.jp FALSE", () => {
        const result = isValidEmail("テスト.ut@enechange.co.jp");
        expect(result).toBeFalsy();
      });

      it("test.ut@enechange.テスト.jp FALSE", () => {
        const result = isValidEmail("test.ut@enechange.テスト.jp");
        expect(result).toBeFalsy();
      });
    });
  });
});
