<template>
  <div>
    <!-- ヘッダー -->
    <the-header></the-header>
  </div>
</template>

<script lang="ts">
import { Component, Vue } from "vue-property-decorator";

@Component({
  components: {
    TheHeader: () => import("@/components/parts/TheHeader.vue"),
  },
})
export default class SimulationPage extends Vue {}
</script>
