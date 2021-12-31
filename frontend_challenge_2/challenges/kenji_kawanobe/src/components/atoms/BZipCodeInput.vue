<template>
  <div class="base-zipcode atom-input">
    <input maxlength="3" v-model="inputFirstZipCode" />
    <div class="base-zipcode_hyphen">-</div>
    <input maxlength="4" v-model="inputSecondZipCode" />
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";
import { halfWidthNumber } from "@/util/stringUtil";

@Component
export default class BZipCodeInput extends Vue {
  @Prop({ type: String, required: true }) firstZipCode!: string;
  @Prop({ type: String, required: true }) secondZipCode!: string;

  get inputFirstZipCode(): string {
    return this.firstZipCode;
  }
  set inputFirstZipCode(v: string) {
    this.$emit("update:firstZipCode", halfWidthNumber(v));
  }

  get inputSecondZipCode(): string {
    return this.secondZipCode;
  }
  set inputSecondZipCode(v: string) {
    this.$emit("update:secondZipCode", halfWidthNumber(v));
  }
}
</script>

<style scoped lang="scss">
.base-zipcode {
  > input {
    text-align: center;
  }
  &_hyphen {
    padding: 0.8rem;
    font-size: 1.5rem;
    background: $border;
  }
}
</style>
