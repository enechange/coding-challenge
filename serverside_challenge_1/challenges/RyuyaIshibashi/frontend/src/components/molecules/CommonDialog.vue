<template>
  <v-dialog
    v-model="dialog.isShow"
  >
    <v-card class="error-dialog">
      <v-row
        justify="center"
        class="text-center pb-8"
      >
        <h3>{{ dialog.title }}</h3>
      </v-row>
      <v-row
        justify="center"
        class="text-center body2"
      >
        {{ dialog.message }}
      </v-row>
      <v-row
        justify="center"
        class="text-center pt-11"
      >
        <v-btn
          color="red"
          text
          small
          @click="$emit('clickCloseButton', $event, {})"
        >
          <v-icon left>
            mdi-close
          </v-icon> 閉じる
        </v-btn>
      </v-row>
    </v-card>
  </v-dialog>
</template>

<script>
export default {
  name: 'CommonDialog',
  props: {
    dialog: {
      type: Object,
      required: true,
      isShow: {
        type: Boolean,
        required: true,
      },
      title: {
        type: String,
        required: true,
      },
      message: {
        type: String,
        required: true,
      },
    },
  },
};
</script>

<style lang="scss" scoped>
.error-dialog {
  padding: 32px;
}
</style>
