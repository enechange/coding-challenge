<template>
  <div class="a_input-box" :class="{ disabled: disabled }">
    <input
      class="a_input-box_input"
      :disabled="disabled"
      v-model="inputValue"
    />
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";

@Component
export default class BInput extends Vue {
  @Prop({ type: [String, Number, Object] }) value!: string | number | null;
  @Prop({ type: Boolean, default: false }) disabled!: boolean;

  get inputValue(): string | number | null {
    return this.value;
  }
  set inputValue(value: string | number | null) {
    this.$emit("input", value);
  }
}
</script>
