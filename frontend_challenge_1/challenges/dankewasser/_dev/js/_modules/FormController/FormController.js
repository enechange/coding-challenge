import Vue from 'vue';
import InputText from './components/InputText/InputText.vue';
import Select from './components/Select/Select.vue';
import { formSelectTable } from '../../_data/_formSelectTable';

window.Promise = Promise;
Vue.config.productionTip = false;

/**
 * フォームコントローラ
 */
export default {
  components: {
    InputText,
    Select,
  },
  data() {
    return {
      /**
       * 都道府県リスト
       */
      selectList: {
        provider: formSelectTable.provider,
        pref: formSelectTable.providerToPref,
      },
      /**
       * 送信する値
       */
      sendValues: {
        provider: 'tepco',
        pref: '',
        company: '',
        name: '',
        phone: '',
        email: '',
      },
      /**
       * 各フィールドのバリデーション結果
       */
      validateStatus: {
        provider: {
          validateType: 'text',
          isValid: true,
        },
        pref: {
          validateType: 'text',
          isValid: true,
        },
        company: {
          validateType: 'text',
          isValid: true,
        },
        name: {
          validateType: 'text',
          isValid: true,
        },
        phone: {
          validateType: 'text',
          isValid: true,
        },
        email: {
          validateType: 'email',
          isValid: true,
        },
      },
    };
  },
  computed: {
    /**
     * 電力会社リストを返却
     * @returns {{name: string, value: string}[]}
     */
    getProviderList() {
      return this.selectList.provider;
    },
    /**
     * 都道府県リストに「お選びください」を付加して返却
     * @returns {{name: string, value: string}[]}
     */
    getPrefList() {
      return [
        {
          name: 'お選びください',
          value: '',
        },
      ].concat(this.selectList.pref[this.sendValues.provider].pref);
    },
  },
  methods: {
    /**
     * 保持している送信する値を反映し、即時バリデーション
     * @param name {String} - 変更対象のキー
     * @param value {String} - 変更する値
     */
    changeSendValue(name, value) {
      this.$set(this.sendValues, name, value);
      this.validate(name);
    },
    /**
     * リストが変更された場合、引数で与えられたフィールドを初期化する
     * （電力会社が変更される場合に都道府県を初期化するなど）
     * @param name {String} - 変更対象のキー
     */
    onChangeList(name) {
      this.$set(this.sendValues, name, '');
    },
    /**
     * すべてのフィールドに対してバリデーションを呼び出す
     * @returns {boolean} - すべてバリデーションが通れば true
     */
    validateAll() {
      for (const name in this.sendValues) {
        this.validate(name);
      }

      let isValid = true;

      for (const value of Object.values(this.validateStatus)) {
        if (!value.isValid) isValid = false;
      }

      return isValid;
    },
    /**
     * フィールドをバリデーションする
     * @param key {String} - バリデーション対象のフィールド名
     */
    validate(key) {
      let isValid = false;

      switch (this.validateStatus[key].validateType) {
        case 'text':
          if (this.sendValues[key] !== '') isValid = true;
          break;
        case 'email':
          if (this.sendValues[key].match(/^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/)) {
            isValid = true;
          }
          break;
        default:
          isValid = true;
      }

      this.$set(this.validateStatus[key], 'isValid', isValid);
    },
    /**
     * Submit時の処理（すべてのフィールドをバリデーションし、それが通れば送信する）
     */
    onSubmit() {
      if (this.validateAll()) {
        alert('入力エラーがないため送信します（テストゆえ送信しないため仮に表示）');
      }
    },
  },
};
