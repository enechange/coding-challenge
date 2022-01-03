<template>
  <div>
    <b-label :is-required="true">
      <template v-slot:label>プラン</template>
    </b-label>
    <b-select
      :disabled="planOptions.length === 0"
      :options="planOptions"
      v-model="simulationData.plan"
      :explain="explain"
    ></b-select>
    <b-info-message v-if="explain">
      <template v-slot:message>{{ explain }}</template>
    </b-info-message>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Watch } from "vue-property-decorator";
import { ISimulation, SelectOption } from "@/types";
import { getPlanOptions } from "@/util/optionsUtil";

@Component({
  components: {
    BLabel: () => import("@/components/atoms/BLabel.vue"),
    BSelect: () => import("@/components/atoms/BSelect.vue"),
    BInfoMessage: () => import("@/components/atoms/BInfoMessage.vue"),
  },
})
export default class PlanForm extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;

  planOptions: (SelectOption & { explain: string })[] = [];

  get explain(): string | undefined {
    const target = this.planOptions.find((option) => {
      return option.value === this.simulationData.plan;
    });
    return target?.explain;
  }

  @Watch("simulationData.company")
  setPlanOption(): void {
    this.planOptions = getPlanOptions(this.simulationData.company);
  }
}
</script>
