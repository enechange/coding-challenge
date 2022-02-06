<template>
  <v-dialog
    v-model="nowLoading"
    persistent
    class="loadingDialog"
  >
    <v-progress-circular
      class="loading-circle"
      :size="100"
      :width="4"
      color="white"
      indeterminate
    />
  </v-dialog>
</template>

<script>
export default {
  name: 'Loading',
  props: {
    nowLoading: {
      type: Boolean,
      required: false,
      default: false,
    },
  },
  data() {
    return {};
  },
};
</script>

<style lang="scss" scoped>
.loading-circle {
  position: fixed;
  top: 0px;
  right: 0px;
  bottom: 0px;
  left: 0px;
  margin: auto;
}
</style>
