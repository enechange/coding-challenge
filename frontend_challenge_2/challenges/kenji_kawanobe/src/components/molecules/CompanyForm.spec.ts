import { shallowMount } from "@vue/test-utils";
import CompanyForm from "@/components/molecules/CompanyForm.vue";
import BErrorMessage from "@/components/atoms/BErrorMessage.vue";
import { companyTypes, ISimulation } from "@/types";

describe("CompanyForm.vue", () => {
  describe("エラーメッセージの表示確認", () => {
    const simulationData = {
      company: companyTypes.OTHER,
    } as ISimulation;

    it("「その他」を選択した場合は表示される", () => {
      const wrapper = shallowMount(CompanyForm, {
        propsData: { simulationData },
      });
      expect(wrapper.findComponent(BErrorMessage).exists()).toBeTruthy();
    });

    it("「その他以外」を選択した場合は表示されない", () => {
      simulationData.company = companyTypes.TOKYO_DENRYOKU;
      const wrapperTokyo = shallowMount(CompanyForm, {
        propsData: { simulationData },
      });
      expect(wrapperTokyo.findComponent(BErrorMessage).exists()).toBeFalsy();

      simulationData.company = companyTypes.KANSAI_DENRYOKU;
      const wrapperKansai = shallowMount(CompanyForm, {
        propsData: { simulationData },
      });
      expect(wrapperKansai.findComponent(BErrorMessage).exists()).toBeFalsy();
    });
  });
});
