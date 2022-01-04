<template>
  <span class="a_label" :class="{ a_label_required: isRequired }">
    <slot name="label"></slot>
  </span>
</template>

<script lang="ts">
import { Component, Vue, Prop } from "vue-property-decorator";

@Component
export default class BLabel extends Vue {
  @Prop({ type: Boolean, default: false }) isRequired!: boolean;
}
</script>

<style scoped lang="scss">
.a_label {
  font-weight: bold;
  display: flex;
  margin: 0.4rem 0rem;
  font-size: 1.2rem;
  align-items: center;

  &_required {
    &::before {
      content: "必須";
      text-align: center;
      color: $white;
      background: $required;
      margin-right: -0.8rem;
      padding: 0.2rem 0.5rem;
      font-size: 1.2rem;
      line-height: 1.8rem;
      letter-spacing: 0.4rem;
      text-indent: 0.4rem;
      transform: scale(0.7) translateX(-1rem);
      // 各ブラウザに対応するため以下を設定
      -webkit-transform: scale(0.7) translateX(-1rem);
      -moz-transform: scale(0.7) translateX(-1rem);
      -ms-transform: scale(0.7) translateX(-1rem);
      -o-transform: scale(0.7) translateX(-1rem);
    }
  }
}
</style>
