<template>
  <div class="a_select" :class="{ disabled: disabled }" :style="styleVariables">
    <div class="a_select_icon">
      <i class="fas fa-chevron-down fa-2x"></i>
    </div>
    <select class="a_select_select" :disabled="disabled" v-model="selectValue">
      <option
        v-for="(option, index) in options"
        :value="option.value"
        :selected="option.selected"
        :key="index"
      >
        {{ option.label }}
      </option>
    </select>
  </div>
</template>

<script lang="ts">
import { Component, Vue, Prop, Watch } from "vue-property-decorator";
import { SelectOption } from "@/types";

@Component
export default class BSelect extends Vue {
  @Prop({ type: String, required: true }) value!: string;
  @Prop({ type: Boolean, default: false }) disabled!: boolean;
  @Prop({
    type: Array,
    default: () => [],
  })
  options!: (SelectOption & { explain?: string })[];
  @Prop({ type: String, default: "" }) explain!: string;

  get selectValue(): string {
    return this.value;
  }
  set selectValue(value: string) {
    this.$emit("input", value);
  }

  get styleVariables(): Record<string, string> {
    return {
      "--border-radius": this.explain ? "0.4rem 0.4rem 0 0" : "0.4rem",
    };
  }

  @Watch("options")
  renewOptions(): void {
    if (this.options.length > 0) {
      this.$emit("input", this.options[0].value);
    } else {
      this.$emit("input", "");
    }
  }
}
</script>

<style scoped lang="scss">
$--border-radius: 0.4rem;
.a_select {
  cursor: pointer;
  display: flex;
  border: 0.4rem solid $border;
  border-radius: var(--border-radius);
  position: relative;

  &_icon {
    position: absolute;
    top: 0.7rem;
    left: 0.7rem;
    color: $orange;
  }

  &_select {
    cursor: pointer;
    width: 100%;
    border: none;
    outline: none;
    background: $white;
    padding: 1rem 0rem 1rem 3.3rem;

    // 右端のデフォルトの記号を削除
    -webkit-appearance: none; /* ベンダープレフィックス(Google Chrome、Safari用) */
    -moz-appearance: none; /* ベンダープレフィックス(Firefox用) */
    appearance: none; /* 標準のスタイルを無効にする */

    &:focus {
      // https://ics.media/entry/200406/
      box-shadow: $box-shadow-focus;
    }

    &:disabled {
      cursor: default;
    }
  }
}
</style>
