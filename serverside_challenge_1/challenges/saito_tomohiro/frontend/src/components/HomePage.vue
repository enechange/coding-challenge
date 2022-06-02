<template>
    <v-container class="py-8 px-6">
    <v-row>
      <v-col>
      <div>契約アンペア数 [A]</div>
        <v-select
          :items="amperes"
          label="契約アンペア数"
        ></v-select>
      <div>電力会社</div>
        <v-select
          :items="companies"
          label="契約アンペア数"
        ></v-select>
        <v-btn @click="culculatePrice">結果を見る</v-btn>
      </v-col>
    </v-row>

    <v-row>
      <v-col>
        <div>基本料金：</div>
        <div>従量料金：</div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from "axios";

  export default {
    name: 'HelloWorld',

    data: () => ({
      amperes: [10, 15, 20, 30, 40, 50, 60],
      companies: ["東京電力エナジーパートナー / 従量電灯B ", "Loopでんき / おうちプラン", "東京ガス / ずっとも電気1", "JXTGでんき / 従量電灯Bたっぷりプラン"],
    }),
      methods: {
    async culculatePrice() {
      try {
        this.error = null;
        const res = await axios.post(
          `${process.env.VUE_APP_API_URL}/api/auth/sign_in`,
        );
        console.log({ res });
        return res;
      } catch (error) {
        console.log({ error });
        this.error = "メールアドレスかパスワードが違います";
      }
    },
  },
  }
</script>
