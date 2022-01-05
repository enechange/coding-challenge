<template>
  <div>
    <b-heading>
      <template v-slot:heading>郵便番号をご入力ください</template>
    </b-heading>
    <div class="o_box-form">
      <zip-code-form :simulationData="simulationData"></zip-code-form>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";
import BHeading from "@/components/atoms/BHeading.vue";
import ZipCodeForm from "@/components/molecules/ZipCodeForm.vue";
import { ISimulation } from "@/types";

@Component({
  components: {
    BHeading,
    ZipCodeForm,
  },
})
export default class ZipCodeBox extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;
}
</script>
