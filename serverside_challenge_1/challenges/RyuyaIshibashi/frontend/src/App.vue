<template>
  <v-app>
    <v-container>
      <router-view />
    </v-container>

    <ScrollButton />

    <CommonDialog
      :dialog="$store.state.root.app.errorDialog"
      @clickCloseButton="clickCloseButtonAtErrorDialog"
    />

    <Loading :now-loading="$store.state.root.app.nowLoading" />
  </v-app>
</template>

<script>
import CommonDialog from '@/components/molecules/CommonDialog.vue';
import Loading from '@/components/atoms/Loading.vue';
import ScrollButton from '@/components/atoms/ScrollButton.vue';

export default {
  name: 'App',
  components: {
    CommonDialog,
    Loading,
    ScrollButton,
  },
  data: () => ({
    simulations: [],
  }),
  methods: {
    clickCloseButtonAtErrorDialog() {
      this.$store.dispatch('updateErrorDialog', {
        isShow: false,
        title: '',
        message: '',
      });
    },
  },
};
</script>
<style lang="scss">
$color-pack: false;
@import '~vuetify/src/styles/main.sass';
@import './src/assets/styles/vars.scss';
.v-application {
  .text-h1,
  .text-h2,
  .text-h3,
  .text-h4,
  .text-h5,
  .text-h6,
  .text-subtitle-1,
  .text-subtitle-2,
  .text-body-1,
  .text-body-2,
  .text-button,
  .text-caption,
  .text-overline {
    font-family: $body-font-family !important;
    color: $color-grey-01;
  }
  .text-body-2 {
    font-size: 1rem !important;
  }
  p {
    margin-bottom: 0;
  }
}
.theme--light.v-application,
.theme--light.v-chip {
  font-family: $body-font-family !important;
  color: $color-grey-01 !important;
}

#app {
  font-family: $body-font-family;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
.row {
  margin-right: 0;
  margin-left: 0;
}
@media (min-width: 1264px) {
  .container {
    max-width: 960px;
  }
}
</style>
