module.exports = {
  publicPath: "/coding-challenge",
  outputDir: "../../../docs",
  css: {
    loaderOptions: {
      scss: {
        prependData: `@import "@/assets/app.scss";`,
      },
    },
  },
};
