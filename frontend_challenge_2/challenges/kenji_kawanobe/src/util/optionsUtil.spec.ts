import { areaTypes, companyTypes, planTypes, ISimulation } from "@/types";
import {
  getCompanyOptions,
  getPlanOptions,
  getAmpsOption,
} from "@/util/optionsUtil";

describe("optionsUtil", () => {
  describe("getCompanyOptions", () => {
    it("東京エリアの場合 「東京電力/その他」が選択肢となる", () => {
      const options = getCompanyOptions(areaTypes.TOKYO);
      expect(options).toHaveLength(2);
      expect(options[0]).toEqual({
        value: companyTypes.TOKYO_DENRYOKU,
        label: companyTypes.TOKYO_DENRYOKU,
        selected: true,
      });
      expect(options[1]).toEqual({
        value: companyTypes.OTHER,
        label: companyTypes.OTHER,
      });
    });

    it("関西エリアの場合 「関西電力/その他」が選択肢となる", () => {
      const options = getCompanyOptions(areaTypes.KANSAI);
      expect(options).toHaveLength(2);
      expect(options[0]).toEqual({
        value: companyTypes.KANSAI_DENRYOKU,
        label: companyTypes.KANSAI_DENRYOKU,
        selected: true,
      });
      expect(options[1]).toEqual({
        value: companyTypes.OTHER,
        label: companyTypes.OTHER,
      });
    });

    it("サービス対象外の場合 選択肢が取得できない", () => {
      const options = getCompanyOptions(areaTypes.OTHER);
      expect(options).toHaveLength(0);
    });
  });

  describe("getPlanOptions", () => {
    it("東京電力の場合 「従量電灯B/従量電灯C」が選択肢となる", () => {
      const options = getPlanOptions(companyTypes.TOKYO_DENRYOKU);
      expect(options).toHaveLength(2);
      expect(options[0]).toEqual({
        value: planTypes.PLAN_B,
        label: planTypes.PLAN_B,
        explain: `${planTypes.PLAN_B}の説明`,
        selected: true,
      });
      expect(options[1]).toEqual({
        value: planTypes.PLAN_C,
        label: planTypes.PLAN_C,
        explain: `${planTypes.PLAN_C}の説明`,
      });
    });

    it("関西電力の場合 「従量電灯B/従量電灯C」が選択肢となる", () => {
      const options = getPlanOptions(companyTypes.TOKYO_DENRYOKU);
      expect(options).toHaveLength(2);
      expect(options[0]).toEqual({
        value: planTypes.PLAN_B,
        label: planTypes.PLAN_B,
        explain: `${planTypes.PLAN_B}の説明`,
        selected: true,
      });
      expect(options[1]).toEqual({
        value: planTypes.PLAN_C,
        label: planTypes.PLAN_C,
        explain: `${planTypes.PLAN_C}の説明`,
      });
    });

    it("その他の場合 選択肢が取得できない", () => {
      const options = getPlanOptions(companyTypes.OTHER);
      expect(options).toHaveLength(0);
    });
  });

  describe("getAmpsOption", () => {
    describe("東京電力の場合", () => {
      it("プランが従量電灯B の場合 「10A/15A/20A/30A/40A/50A/60A」が選択肢となる", () => {
        const simulationData = {
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
        } as ISimulation;
        const options = getAmpsOption(simulationData);
        expect(options).toHaveLength(7);
        expect(options[0]).toEqual({
          label: "10A",
          value: "10A",
          selected: true,
        });
        expect(options[1]).toEqual({
          label: "15A",
          value: "15A",
          selected: false,
        });
        expect(options[2]).toEqual({
          label: "20A",
          value: "20A",
          selected: false,
        });
        expect(options[3]).toEqual({
          label: "30A",
          value: "30A",
          selected: false,
        });
        expect(options[4]).toEqual({
          label: "40A",
          value: "40A",
          selected: false,
        });
        expect(options[5]).toEqual({
          label: "50A",
          value: "50A",
          selected: false,
        });
        expect(options[6]).toEqual({
          label: "60A",
          value: "60A",
          selected: false,
        });
      });

      it("プランが従量電灯C の場合 「6kVAから49kVAまで1kVA刻み」が選択肢となる", () => {
        const simulationData = {
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_C,
        } as ISimulation;
        const options = getAmpsOption(simulationData);
        expect(options).toHaveLength(44);
        for (let i = 0; i++; i < 45) {
          expect(options[i]).toEqual({
            label: `${i + 6}kVA`,
            value: `${i + 6}kVA`,
            selected: true,
          });
        }
      });
    });

    describe("関西電力の場合", () => {
      it("プランが従量電灯A の場合 選択肢が取得できない", () => {
        const simulationData = {
          company: companyTypes.KANSAI_DENRYOKU,
          plan: planTypes.PLAN_A,
        } as ISimulation;
        const options = getAmpsOption(simulationData);
        expect(options).toHaveLength(0);
      });

      it("プランが従量電灯B の場合 「6kVAから49kVAまで1kVA刻み」が選択肢となる", () => {
        const simulationData = {
          company: companyTypes.KANSAI_DENRYOKU,
          plan: planTypes.PLAN_B,
        } as ISimulation;
        const options = getAmpsOption(simulationData);
        expect(options).toHaveLength(44);
        for (let i = 0; i++; i < 45) {
          expect(options[i]).toEqual({
            label: `${i + 6}kVA`,
            value: `${i + 6}kVA`,
            selected: true,
          });
        }
      });
    });
  });
});
