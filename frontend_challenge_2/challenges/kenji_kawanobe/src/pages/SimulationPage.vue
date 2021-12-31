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
    <!-- フッター -->
    <the-footer :send="send" :disabled="false"></the-footer>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";
import { companyTypes, planTypes, ISimulation } from "@/types";
import { sendSimulationData } from "@/server/api";

@Component({
  components: {
    TheHeader: () => import("@/components/parts/TheHeader.vue"),
    ZipCodeBox: () => import("@/components/organisms/ZipCodeBox.vue"),
    StatusBox: () => import("@/components/organisms/StatusBox.vue"),
    TheFooter: () => import("@/components/parts/TheFooter.vue"),
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
