<template>
  <div>
    <b-heading>
      <template v-slot:heading
        >現在の電気の使用状況について教えてください</template
      >
    </b-heading>
    <div class="o_box-form">
      <pay-form
        :simulationData="simulationData"
        :disabled="!isEnabledPayInput"
      ></pay-form>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";
import { isEnabledPayInput as isEnabledPayInputUtil } from "@/util/enabledUtil";
import { ISimulation } from "@/types";

@Component({
  components: {
    BHeading: () => import("@/components/atoms/BHeading.vue"),
    PayForm: () => import("@/components/molecules/PayForm.vue"),
  },
})
export default class PayBox extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;

  get isEnabledPayInput(): boolean {
    return isEnabledPayInputUtil(this.simulationData);
  }
}
</script>
