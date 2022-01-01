<template>
  <div>
    <b-label :is-required="true">
      <template v-slot:label>先月の電気代は？</template>
    </b-label>
    <div class="pay-input">
      <b-input
        :value="simulationData.pay"
        @input="setPayValue"
        :disabled="disabled"
      >
      </b-input>
      <span class="pay-input_unit">円</span>
    </div>
    <b-error-message v-if="isError">
      <template v-slot:message>電気代を正しく入力してください。</template>
    </b-error-message>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Watch } from "vue-property-decorator";
import { ISimulation } from "@/types";
import { isValidPay } from "@/util/validationUtil";
import { halfWidthNumber } from "@/util/stringUtil";

@Component({
  components: {
    BLabel: () => import("@/components/atoms/BLabel.vue"),
    BInput: () => import("@/components/atoms/BInput.vue"),
    BErrorMessage: () => import("@/components/atoms/BErrorMessage.vue"),
  },
})
export default class PayForm extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;
  @Prop({ type: Boolean, default: false }) disabled!: boolean;

  isError = false;

  setPayValue(value: string): void {
    this.simulationData.pay = halfWidthNumber(value).replace(/^0+/, "");
  }

  @Watch("simulationData.pay")
  check(): void {
    this.isError = !isValidPay(this.simulationData.pay);
  }
}
</script>
<style scoped lang="scss">
.pay-input {
  display: flex;
  align-items: center;

  &_unit {
    font-size: 1.2rem;
    margin-left: 1rem;
    flex-basis: 5%;
  }
}
</style>
>
