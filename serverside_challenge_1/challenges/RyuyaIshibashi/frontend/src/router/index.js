import Vue from 'vue';
import VueRouter from 'vue-router';
import Simulation from '../components/template/Simulation.vue';

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    name: 'Simulation',
    component: Simulation,
  },
];

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes,
});

export default router;
