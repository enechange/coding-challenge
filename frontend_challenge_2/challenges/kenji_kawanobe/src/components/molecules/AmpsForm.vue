<template>
  <div>
    <b-label :is-required="true">
      <template v-slot:label>契約容量</template>
    </b-label>
    <b-select
      :disabled="ampsOption.length === 0"
      :options="ampsOption"
      v-model="simulationData.amps"
    ></b-select>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Watch } from "vue-property-decorator";
import BLabel from "@/components/atoms/BLabel.vue";
import BSelect from "@/components/atoms/BSelect.vue";
import { ISimulation, SelectOption } from "@/types";
import { getAmpsOption } from "@/util/optionsUtil";

@Component({
  components: {
    BLabel,
    BSelect,
  },
})
export default class AmpsForm extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;

  ampsOption: SelectOption[] = [];

  @Watch("simulationData.plan")
  setAmpsOption(): void {
    this.ampsOption = getAmpsOption(this.simulationData);
  }
}
</script>
