<template>
  <div class="a_input-box">
    <input
      class="a_zipcode-input_input a_input-box_input"
      maxlength="3"
      v-model="inputFirstZipCode"
    />
    <div class="a_zipcode-input_hyphen">-</div>
    <input
      ref="secondZipCode"
      class="a_zipcode-input_input a_input-box_input"
      maxlength="4"
      v-model="inputSecondZipCode"
    />
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
    const convertedValue = halfWidthNumber(v);
    if (!isNaN(Number(convertedValue)) && convertedValue.length === 3) {
      (this.$refs.secondZipCode as HTMLInputElement).focus();
    }
    this.$emit("update:firstZipCode", convertedValue);
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
.a_zipcode-input {
  &_input {
    text-align: center;
  }
  &_hyphen {
    padding: 0.8rem;
    font-size: 1.5rem;
    background: $border;
  }
}
</style>
