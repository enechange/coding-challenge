import client from '@/scripts/api/client';
import API from '@/scripts/api/api';
import * as types from './mutation-types';

export default {
  async callClientGet(ctx, payload) {
    try {
      ctx.commit(types.UPDATE_NOW_LOADING, true);
      const result = await client.post(
        payload.api,
        payload.params,
      );

      ctx.commit(types.UPDATE_NOW_LOADING, false);
      return result;
    } catch (e) {
      ctx.commit(types.UPDATE_NOW_LOADING, false);
      ctx.dispatch('systemErrorDialog', e.response);
      throw e;
    }
  },

  async systemErrorDialog(ctx, err) {
    const payload = {
      isShow: true,
      title: 'システムエラー',
      message: 'システムエラーが発生しました。',
    };
    if (err.data && err.data.error && err.data.error.message) {
      payload.message = err.data.error.message;
    }
    ctx.dispatch('updateErrorDialog', payload);
  },

  async updateErrorDialog(ctx, payload) {
    ctx.commit(types.UPDATE_ERROR_DIALOG, payload);
  },

  async callCalculation(ctx, payload) {
    const params = [];
    params.push(`ampere=${payload.ampere}`);
    params.push(`amount=${payload.amount}`);
    return ctx.dispatch('callClientGet', {
      api: API.CALCULATION,
      params,
    });
  },
};
