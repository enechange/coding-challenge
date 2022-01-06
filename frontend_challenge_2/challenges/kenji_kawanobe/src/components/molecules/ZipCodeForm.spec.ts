import { shallowMount } from "@vue/test-utils";
import ZipCodeForm from "@/components/molecules/ZipCodeForm.vue";
import BErrorMessage from "@/components/atoms/BErrorMessage.vue";
import { ISimulation } from "@/types";

describe("ZipCodeForm.vue", () => {
  describe("エラーメッセージの表示確認", () => {
    const simulationData = {
      firstZipCode: "",
      secondZipCode: "",
    } as ISimulation;
    const wrapper = shallowMount(ZipCodeForm, {
      propsData: { simulationData },
    });

    it("不正な郵便番号を入力した場合は表示される", () => {
      wrapper.setProps({
        simulationData: {
          firstZipCode: "222",
          secondZipCode: "4567",
        },
      });
      wrapper.vm.$nextTick(() => {
        expect(wrapper.findComponent(BErrorMessage).exists()).toBeTruthy();
      });
    });

    it("正当な郵便番号を入力した場合は表示されない", () => {
      wrapper.setProps({
        simulationData: {
          firstZipCode: "122",
          secondZipCode: "4567",
        },
      });
      wrapper.vm.$nextTick(() => {
        expect(wrapper.findComponent(BErrorMessage).exists()).toBeFalsy();
      });
    });
  });
});
