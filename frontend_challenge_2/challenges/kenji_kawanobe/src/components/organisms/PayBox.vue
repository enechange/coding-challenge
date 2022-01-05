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
import BHeading from "@/components/atoms/BHeading.vue";
import PayForm from "@/components/molecules/PayForm.vue";
import { isEnabledPayInput as isEnabledPayInputUtil } from "@/util/enabledUtil";
import { ISimulation } from "@/types";

@Component({
  components: {
    BHeading,
    PayForm,
  },
})
export default class PayBox extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;

  get isEnabledPayInput(): boolean {
    return isEnabledPayInputUtil(this.simulationData);
  }
}
</script>
