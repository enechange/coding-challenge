<template>
  <div>
    <b-label :is-required="true">
      <template v-slot:label>プラン</template>
    </b-label>
    <b-select
      :disabled="planOptions.length === 0"
      :options="planOptions"
      :explain="explain"
      v-model="simulationData.plan"
    ></b-select>
    <b-info-message v-if="explain">
      <template v-slot:message>{{ explain }}</template>
    </b-info-message>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Watch } from "vue-property-decorator";
import BLabel from "@/components/atoms/BLabel.vue";
import BSelect from "@/components/atoms/BSelect.vue";
import BInfoMessage from "@/components/atoms/BInfoMessage.vue";
import { ISimulation, SelectOption } from "@/types";
import { getPlanOptions } from "@/util/optionsUtil";

@Component({
  components: {
    BLabel,
    BSelect,
    BInfoMessage,
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
