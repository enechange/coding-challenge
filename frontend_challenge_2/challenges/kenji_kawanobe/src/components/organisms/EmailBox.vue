<template>
  <div>
    <b-heading>
      <template v-slot:heading>メールアドレスをご入力ください</template>
    </b-heading>
    <div class="o_box-form">
      <email-form
        :simulationData="simulationData"
        :disabled="!isEnabledEmailInput"
      ></email-form>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";
import BHeading from "@/components/atoms/BHeading.vue";
import EmailForm from "@/components/molecules/EmailForm.vue";
import { isEnabledEmailInput as isEnabledEmailInputUtil } from "@/util/enabledUtil";
import { ISimulation } from "@/types";

@Component({
  components: {
    BHeading,
    EmailForm,
  },
})
export default class EmailBox extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;

  get isEnabledEmailInput(): boolean {
    return isEnabledEmailInputUtil(this.simulationData);
  }
}
</script>
