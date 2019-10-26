import Vue from 'vue';
import FormController from './_modules/FormController/FormController.vue';
import Slider from './_modules/_slider';
import Scroller from './_modules/_scroller';
import SetViewport from './_modules/_setViewport';

window.Promise = Promise;
Vue.config.productionTip = false;

(() => {
  $(() => {
    const form = document.getElementById('js-FormController');
    if (form) {
      new Vue({
        render: h => h(FormController),
      }).$mount(form);
    }

    const scroller = new Scroller();
    scroller.init();

    const slider = new Slider(); // eslint-disable-line no-unused-vars
  });

  const setViewport = new SetViewport(); // eslint-disable-line no-unused-vars
})();
