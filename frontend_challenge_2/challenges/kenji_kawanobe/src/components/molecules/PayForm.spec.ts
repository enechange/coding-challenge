import { shallowMount } from "@vue/test-utils";
import PayForm from "@/components/molecules/PayForm.vue";
import BErrorMessage from "@/components/atoms/BErrorMessage.vue";
import { ISimulation } from "@/types";

describe("PayForm.vue", () => {
  describe("エラーメッセージの表示確認", () => {
    const simulationData = {} as ISimulation;
    const wrapper = shallowMount(PayForm, {
      propsData: { simulationData },
    });

    it("不正な支払金額を入力した場合は表示される", () => {
      wrapper.setProps({
        simulationData: {
          pay: "999",
        },
      });
      wrapper.vm.$nextTick(() => {
        expect(wrapper.findComponent(BErrorMessage).exists()).toBeTruthy();
      });
    });

    it("正当な支払金額を入力した場合は表示されない", () => {
      wrapper.setProps({
        simulationData: {
          pay: "1000",
        },
      });
      wrapper.vm.$nextTick(() => {
        expect(wrapper.findComponent(BErrorMessage).exists()).toBeFalsy();
      });
    });
  });
});
