<template>
  <div id="app">
    <router-view />
  </div>
</template>

<style lang="scss">
html {
  font-size: 62.5%;
  @media only screen and (min-width: 1200px) {
    background: #474747;
  }
}

body {
  margin: 0;
  padding: 0;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  color: #474747;
  background: #f8f8f8;
  @media only screen and (min-width: 1200px) {
    width: 600px;
    margin: 0 auto;
  }
}
</style>
