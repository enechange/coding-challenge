<template>
  <div>
    <b-heading>
      <template v-slot:heading>電気のご使用状況について教えてください</template>
    </b-heading>

    <div class="o_box-form">
      <company-form :simulationData="simulationData"></company-form>
    </div>
    <div class="o_box-form">
      <plan-form :simulationData="simulationData"></plan-form>
    </div>
    <div class="o_box-form">
      <amps-form :simulationData="simulationData"></amps-form>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";
import BHeading from "@/components/atoms/BHeading.vue";
import CompanyForm from "@/components/molecules/CompanyForm.vue";
import PlanForm from "@/components/molecules/PlanForm.vue";
import AmpsForm from "@/components/molecules/AmpsForm.vue";
import { ISimulation } from "@/types";

@Component({
  components: {
    BHeading,
    CompanyForm,
    PlanForm,
    AmpsForm,
  },
})
export default class StatusBox extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;
}
</script>
