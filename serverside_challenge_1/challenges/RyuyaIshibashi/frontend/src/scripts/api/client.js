import axios from 'axios';

const BASE_URL = 'https://ryuya-serverside.herokuapp.com/';
export default {
  async post(api, params) {
    let sendURL = BASE_URL + api;
    for (let i = 0; i < params.length; i += 1) {
      const param = params[i];
      if (param !== '' && typeof param === 'string' && param.indexOf('=') !== -1) {
        const conjunction = (i === 0) ? '?' : '&';
        sendURL = sendURL + conjunction + param;
      }
    }
    sendURL = encodeURI(sendURL);
    const result = await axios.get(sendURL);
    return result;
  },
};
