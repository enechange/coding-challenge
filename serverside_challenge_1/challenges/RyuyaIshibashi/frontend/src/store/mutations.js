import Vue from 'vue';
import * as types from './mutation-types';

export default {
  [types.UPDATE_NOW_LOADING](state, payload) {
    Vue.set(state.root.app, 'nowLoading', payload);
  },
  [types.UPDATE_ERROR_DIALOG](state, payload) {
    Vue.set(state.root.app, 'errorDialog', payload);
  },
};
