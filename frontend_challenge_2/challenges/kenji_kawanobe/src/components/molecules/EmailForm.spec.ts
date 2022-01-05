import { shallowMount } from "@vue/test-utils";
import EmailForm from "@/components/molecules/EmailForm.vue";
import BErrorMessage from "@/components/atoms/BErrorMessage.vue";
import { ISimulation } from "@/types";

describe("EmailForm.vue", () => {
  describe("エラーメッセージの表示確認", () => {
    const simulationData = {} as ISimulation;
    const wrapper = shallowMount(EmailForm, {
      propsData: { simulationData },
    });

    it("不正なメールアドレスを入力した場合は表示される", () => {
      wrapper.setProps({
        simulationData: {
          email: "test@enechange",
        },
      });
      wrapper.vm.$nextTick(() => {
        expect(wrapper.findComponent(BErrorMessage).exists()).toBeTruthy();
      });
    });

    it("正当なメールアドレスを入力した場合は表示されない", () => {
      wrapper.setProps({
        simulationData: {
          email: "test@enechange.jp",
        },
      });
      wrapper.vm.$nextTick(() => {
        expect(wrapper.findComponent(BErrorMessage).exists()).toBeFalsy();
      });
    });
  });
});
