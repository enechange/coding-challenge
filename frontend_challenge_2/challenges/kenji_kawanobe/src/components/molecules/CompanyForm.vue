<template>
  <div>
    <b-label :is-required="true">
      <template v-slot:label>電力会社</template>
    </b-label>
    <b-select
      :disabled="companyOptions.length === 0"
      :options="companyOptions"
      v-model="simulationData.company"
    ></b-select>
    <b-error-message v-if="isOtherCompany">
      <template v-slot:message>シミュレーション対象外です。</template>
    </b-error-message>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Watch } from "vue-property-decorator";
import BLabel from "@/components/atoms/BLabel.vue";
import BSelect from "@/components/atoms/BSelect.vue";
import BErrorMessage from "@/components/atoms/BErrorMessage.vue";
import { SelectOption, ISimulation, companyTypes } from "@/types";
import { getCompanyOptions } from "@/util/optionsUtil";

@Component({
  components: {
    BLabel,
    BSelect,
    BErrorMessage,
  },
})
export default class CompanyForm extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;

  companyOptions: SelectOption[] = [];

  get isOtherCompany(): boolean {
    return this.simulationData.company === companyTypes.OTHER;
  }

  @Watch("simulationData.area")
  setCompanyOption(): void {
    this.companyOptions = getCompanyOptions(this.simulationData.area);
  }
}
</script>
