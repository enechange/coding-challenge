<template>
  <div class="p_header">
    <div class="p_header_top">
      <div>電気代から<br />かんたんシミュレーション</div>
    </div>
    <div>
      検針票を用意しなくてもOK<br />いくらおトクになるのか今すぐわかります！
    </div>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";

@Component
export default class TheHeader extends Vue {}
</script>

<style scoped lang="scss">
.p_header {
  padding: 2rem 0 2.6rem 0;
  text-align: center;
  font-size: 1.2rem;

  &_top {
    font-size: 1.6rem;
    font-weight: bold;
    letter-spacing: 0.1rem;
    line-height: 2rem;
    padding-bottom: 1.6rem;
  }
}
</style>
