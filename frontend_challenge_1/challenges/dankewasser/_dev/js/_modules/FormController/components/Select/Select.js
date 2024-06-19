/**
 * セレクトボックス
 */
export default {
  name: 'Select',
  props: {
    name: String,
    heading: String,
    list: Array,
    errorMessage: String,
    childList: String,
    currentValue: String,
    isValid: Boolean,
  },
  computed: {
    /**
     * 選択されている値
     */
    selected: {
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
        if (this.selected !== value) {
          if (this.childList) {
            this.$emit('change-list', this.childList);
          }

          this.$emit('change-value', this.name, value);
        }
      },
    },
  },
};
