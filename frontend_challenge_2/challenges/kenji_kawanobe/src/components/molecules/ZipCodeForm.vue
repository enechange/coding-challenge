<template>
  <div>
    <b-label :is-required="true">
      <template v-slot:label>電気を使用する場所の郵便番号</template>
    </b-label>

    <b-zip-code-input
      :firstZipCode.sync="simulationData.firstZipCode"
      :secondZipCode.sync="simulationData.secondZipCode"
    ></b-zip-code-input>
    <b-error-message v-if="isError">
      <template v-slot:message>サービスエリア対象外です。</template>
    </b-error-message>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Watch } from "vue-property-decorator";
import { isValidZipCode } from "@/util/validationUtil";
import { ISimulation } from "@/types";

@Component({
  components: {
    BLabel: () => import("@/components/atoms/BLabel.vue"),
    BZipCodeInput: () => import("@/components/atoms/BZipCodeInput.vue"),
    BErrorMessage: () => import("@/components/atoms/BErrorMessage.vue"),
  },
})
export default class ZipCodeForm extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;

  isError = false;

  @Watch("simulationData.firstZipCode")
  @Watch("simulationData.secondZipCode")
  check(): void {
    this.isError = !isValidZipCode(
      this.simulationData.firstZipCode,
      this.simulationData.secondZipCode
    );
  }
}
</script>
