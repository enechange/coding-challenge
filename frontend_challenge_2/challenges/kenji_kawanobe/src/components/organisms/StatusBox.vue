<template>
  <div>
    <b-heading>
      <template v-slot:heading>電気のご使用状況について教えてください</template>
    </b-heading>

    <div class="box-form">
      <company-form :simulationData="simulationData"></company-form>
    </div>
    <div class="box-form">
      <plan-form :simulationData="simulationData"></plan-form>
    </div>
    <div class="box-form">
      <amps-form :simulationData="simulationData"></amps-form>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";
import { ISimulation } from "@/types";

@Component({
  components: {
    BHeading: () => import("@/components/atoms/BHeading.vue"),
    CompanyForm: () => import("@/components/molecules/CompanyForm.vue"),
    PlanForm: () => import("@/components/molecules/PlanForm.vue"),
    AmpsForm: () => import("@/components/molecules/AmpsForm.vue"),
  },
})
export default class StatusBox extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;
}
</script>
