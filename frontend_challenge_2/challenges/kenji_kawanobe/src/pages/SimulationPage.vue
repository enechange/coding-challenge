<template>
  <div>
    <!-- ヘッダー -->
    <the-header></the-header>
    <!-- 郵便番号 -->
    <div class="simulation-box">
      <zip-code-box :simulationData="simulationData"></zip-code-box>
    </div>
    <!-- 使用状況 -->
    <div class="simulation-box">
      <status-box :simulationData="simulationData"></status-box>
    </div>
    <!-- 支払金額 -->
    <div class="simulation-box">
      <pay-box :simulationData="simulationData"></pay-box>
    </div>
    <!-- メールアドレス -->
    <div class="simulation-box">
      <email-box :simulationData="simulationData"></email-box>
    </div>
    <!-- フッター -->
    <the-footer :send="send" :disabled="!isEnabledSendButton"></the-footer>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import TheHeader from "@/components/parts/TheHeader.vue";
import ZipCodeBox from "@/components/organisms/ZipCodeBox.vue";
import StatusBox from "@/components/organisms/StatusBox.vue";
import PayBox from "@/components/organisms/PayBox.vue";
import EmailBox from "@/components/organisms/EmailBox.vue";
import TheFooter from "@/components/parts/TheFooter.vue";
import { companyTypes, planTypes, ISimulation } from "@/types";
import { sendSimulationData } from "@/server/api";
import { isEnabledSendButton as isEnabledSendButtonUtil } from "@/util/enabledUtil";

@Component({
  components: {
    TheHeader,
    ZipCodeBox,
    StatusBox,
    PayBox,
    EmailBox,
    TheFooter,
  },
})
export default class SimulationPage extends Vue {
  simulationData: ISimulation = {
    firstZipCode: "",
    secondZipCode: "",
    company: companyTypes.UNSELECTED,
    plan: planTypes.UNSELECTED,
    amps: "",
    pay: "",
    email: "",
  };

  get isEnabledSendButton(): boolean {
    return isEnabledSendButtonUtil(this.simulationData);
  }

  send(): void {
    sendSimulationData(this.simulationData);
  }
}
</script>
<style scoped lang="scss">
.simulation-box {
  background: $white;
  padding: 1.6rem 0 3rem 0;
  margin-bottom: 2rem;
}
</style>
