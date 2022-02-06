<template>
  <v-container class="input-textbox">
    <v-row class="margin-label-input-component">
      <v-col>
        <v-text-field
          v-model.trim="inputText"
          flat
          outlined
          color="grey01"
          clearable
          clear-icon="mdi-close-circle"
          :type="inputType"
          :placeholder="params.placeholder"
          :maxlength="params.maxLength"
          :suffix="params.suffix"
        />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  name: 'InputTextbox',
  props: {
    params: {
      type: Object,
      required: true,
    },
    inputType: {
      type: String,
      default: 'text',
      required: false,
    },
  },
  data: () => ({
    inputText: '',
  }),
};
</script>
