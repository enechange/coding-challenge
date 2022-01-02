import { companyTypes, planTypes, ISimulation } from "@/types";
import {
  isEnabledPayInput,
  isEnabledEmailInput,
  isEnabledSendButton,
} from "@/util/enabledUtil";

describe("enabledUtil", () => {
  describe("isEnabledPayInput", () => {
    describe("TRUE となるケース", () => {
      it("郵便番号が対象エリア かつ 会社、プラン、契約容量が選択済み の場合 TRUE", () => {
        const simulationData = {
          firstZipCode: "123",
          secondZipCode: "4567",
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
          amps: "10A",
        } as ISimulation;
        const result = isEnabledPayInput(simulationData);
        expect(result).toBeTruthy();
      });

      it("関西電力 かつ 従量電灯Aの場合は契約容量が未選択でもTRUE", () => {
        const simulationData = {
          firstZipCode: "523",
          secondZipCode: "4567",
          company: companyTypes.KANSAI_DENRYOKU,
          plan: planTypes.PLAN_A,
          amps: "",
        } as ISimulation;
        const result = isEnabledPayInput(simulationData);
        expect(result).toBeTruthy();
      });
    });

    describe("FALSE となるケース", () => {
      it("郵便番号が対象外エリア  の場合 FALSE", () => {
        const simulationData = {
          firstZipCode: "223",
          secondZipCode: "4567",
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
          amps: "10A",
        } as ISimulation;
        const result = isEnabledPayInput(simulationData);
        expect(result).toBeFalsy();
      });

      it("会社が未選択  の場合 FALSE", () => {
        const simulationData = {
          firstZipCode: "123",
          secondZipCode: "4567",
          company: "",
          plan: planTypes.PLAN_B,
          amps: "10A",
        } as ISimulation;
        const result = isEnabledPayInput(simulationData);
        expect(result).toBeFalsy();
      });

      it("プランが未選択  の場合 FALSE", () => {
        const simulationData = {
          firstZipCode: "123",
          secondZipCode: "4567",
          company: companyTypes.TOKYO_DENRYOKU,
          plan: "",
          amps: "10A",
        } as ISimulation;
        const result = isEnabledPayInput(simulationData);
        expect(result).toBeFalsy();
      });

      it("契約容量が未選択  の場合 FALSE", () => {
        const simulationData = {
          firstZipCode: "123",
          secondZipCode: "4567",
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
          amps: "",
        } as ISimulation;
        const result = isEnabledPayInput(simulationData);
        expect(result).toBeFalsy();
      });
    });
  });

  describe("isEnabledEmailInput", () => {
    describe("TRUE となるケース", () => {
      it("最低料金以上の支払金額まで入力されている場合 TRUE", () => {
        const simulationData = {
          firstZipCode: "123",
          secondZipCode: "4567",
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
          amps: "10A",
          pay: 1000,
        } as ISimulation;
        const result = isEnabledEmailInput(simulationData);
        expect(result).toBeTruthy();
      });
    });

    describe("FALSE となるケース", () => {
      it("支払金額まで入力されていない場合 FALSE", () => {
        const simulationData = {
          firstZipCode: "223",
          secondZipCode: "4567",
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
          amps: "10A",
        } as ISimulation;
        const result = isEnabledEmailInput(simulationData);
        expect(result).toBeFalsy();
      });

      it("支払金額まで入力されている かつ 最低料金未満 の場合 FALSE", () => {
        const simulationData = {
          firstZipCode: "223",
          secondZipCode: "4567",
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
          amps: "10A",
          pay: 999,
        } as ISimulation;
        const result = isEnabledEmailInput(simulationData);
        expect(result).toBeFalsy();
      });
    });
  });

  describe("isEnabledSendButton", () => {
    describe("TRUE となるケース", () => {
      it("妥当なメールアドレスまで入力されている場合 TRUE", () => {
        const simulationData = {
          firstZipCode: "123",
          secondZipCode: "4567",
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
          amps: "10A",
          pay: 1000,
          email: "test.ut@enechange.co.jp",
        } as ISimulation;
        const result = isEnabledSendButton(simulationData);
        expect(result).toBeTruthy();
      });
    });

    describe("FALSE となるケース", () => {
      it("メールアドレスまで入力されていない場合 FALSE", () => {
        const simulationData = {
          firstZipCode: "223",
          secondZipCode: "4567",
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
          amps: "10A",
        } as ISimulation;
        const result = isEnabledSendButton(simulationData);
        expect(result).toBeFalsy();
      });

      it("不正なメールアドレスまで入力されている場合 TRUE", () => {
        const simulationData = {
          firstZipCode: "123",
          secondZipCode: "4567",
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
          amps: "10A",
          pay: 1000,
          email: "test.テスト.ut@enechange.co.jp",
        } as ISimulation;
        const result = isEnabledSendButton(simulationData);
        expect(result).toBeFalsy();
      });
    });
  });
});
