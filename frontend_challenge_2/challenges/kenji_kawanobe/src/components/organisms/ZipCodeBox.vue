<template>
  <div>
    <b-heading>
      <template v-slot:heading>郵便番号をご入力ください</template>
    </b-heading>
    <div class="box-form">
      <zip-code-form :simulationData="simulationData"></zip-code-form>
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";
import { ISimulation } from "@/types";

@Component({
  components: {
    BHeading: () => import("@/components/atoms/BHeading.vue"),
    ZipCodeForm: () => import("@/components/molecules/ZipCodeForm.vue"),
  },
})
export default class ZipCodeBox extends Vue {
  @Prop({ type: Object }) simulationData!: ISimulation;
}
</script>
