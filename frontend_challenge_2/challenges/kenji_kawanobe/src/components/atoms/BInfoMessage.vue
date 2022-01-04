<template>
  <div class="a_info-message">
    <p><slot name="message"></slot></p>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";

@Component
export default class BInfoMessage extends Vue {}
</script>

<style scoped lang="scss">
.a_info-message {
  display: flex;
  border-radius: 0 0 0.4rem 0.4rem;
  background: $border;
  align-items: center;
  padding: 0rem 1rem;
  height: 2rem;
  position: relative;

  // https://www.ameamelog.com/css-dotline/
  &::before {
    content: "";
    background-image: linear-gradient(
      to right,
      $white,
      $white 0.1rem,
      transparent 0.1rem,
      transparent 0.2rem
    );
    background-size: 0.2rem 0.1rem;
    background-repeat: repeat-x;
    position: absolute;
    top: 0;
    bottom: 0;
    left: 0;
    right: 0;
  }
}
</style>
