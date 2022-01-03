<template>
  <span class="heading">
    <slot name="heading"></slot>
  </span>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";

@Component
export default class BHeading extends Vue {}
</script>

<style scoped lang="scss">
.heading {
  display: flex;
  font-weight: bold;
  border-left: 0.4rem solid $orange;
  font-size: 1.6rem;
  padding-left: 1.2rem;
  height: 3.5rem;
  align-items: center;
}
</style>
