import { shallowMount } from "@vue/test-utils";
import PlanForm from "@/components/molecules/PlanForm.vue";
import BInfoMessage from "@/components/atoms/BInfoMessage.vue";
import { companyTypes, planTypes, ISimulation } from "@/types";

describe("PlanForm.vue", () => {
  describe("補足メッセージの表示確認", () => {
    const simulationData = {
      company: companyTypes.UNSELECTED,
      plan: planTypes.UNSELECTED,
    } as ISimulation;
    const wrapper = shallowMount(PlanForm, {
      propsData: { simulationData },
    });

    it("プランを選択した場合は表示される", () => {
      wrapper.setProps({
        simulationData: {
          company: companyTypes.TOKYO_DENRYOKU,
          plan: planTypes.PLAN_B,
        },
      });
      wrapper.vm.$nextTick(() => {
        expect(wrapper.findComponent(BInfoMessage).exists()).toBeTruthy();
      });
    });

    it("プランを選択していない場合は表示されない", () => {
      wrapper.setProps({
        simulationData: {
          company: companyTypes.TOKYO_DENRYOKU,
          plan: "",
        },
      });
      wrapper.vm.$nextTick(() => {
        expect(wrapper.findComponent(BInfoMessage).exists()).toBeFalsy();
      });
    });
  });
});
