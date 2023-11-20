/**
 * テキストフィールド
 */
export default {
  name: 'InputText',
  props: {
    name: String,
    type: String,
    heading: String,
    placeholder: String,
    errorMessage: String,
    currentValue: String,
    isValid: Boolean,
  },
  computed: {
    /**
     * 入力された値
     */
    inputted: {
      /**
       * 現在の値を返却
       * @returns {*|StringConstructor|String}
       */
      get() {
        return this.currentValue;
      },
      /**
       * 値が変わっていたら変更を親に通知
       * @param value {string}
       */
      set(value) {
        if (this.inputted !== value) {
          this.$emit('change-value', this.name, value);
        }
      },
    },
  },
};
